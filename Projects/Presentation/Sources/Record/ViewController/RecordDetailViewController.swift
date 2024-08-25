//
//  RecordDetailViewController.swift
//  Presentation
//
//  Created by najin on 7/21/24.
//
    
import UIKit
import RxCocoa
import RxSwift
import ReactorKit
import RxRelay
import RxDataSources
import Domain
import MapKit
import Common

final public class RecordDetailViewController: UIViewController {
    
    //MARK: - Properties
    
    public var coordinator: RecordCoordinatorInterface?
    
    public var postNo: Int?
    private let delegate = RunningMapDelegate()
    
    public var disposeBag = DisposeBag()
    
    private var runningResultView: RunningResultView = {
        return RunningResultView(isRunningResult: false)
    }()
    
    //MARK: - Lifecycle
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(reactor: RecordDetailReactor, postNo: Int){
        super.init(nibName: nil, bundle: nil)
        
        self.postNo = postNo
        self.reactor = reactor
    }
    
    deinit {
        print("deinit RecordDetailViewController")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureUI()
        
        runningResultView.mapArea.mapView.delegate = delegate
    }
    
    //MARK: - Configure
    
    private func configureNavigationBar() {
        self.title = "러닝 기록"
        self.navigationController?.navigationBar.tintColor = .black
        
        let backButton: UIButton = UIButton(type: .custom)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.addTarget(self, action: #selector(customBackAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let moreButton = UIButton()
        moreButton.setImage(CommonAsset.dotsVerticalOutline.image, for: .normal)
        moreButton.addTarget(self, action: #selector(moreAction), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: moreButton)
    }
    
    private func configureUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(runningResultView)
        
        runningResultView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    //MARK: - Helpers
    
    @objc func customBackAction() {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func moreAction() {
        let moreAlert = UIAlertController(
            title: "기록 더보기",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let writeAlertAction = UIAlertAction(title: "현재 기록으로 게시글 쓰기", style: .default) { _ in self.writeAction() }
        let deleteAlertAction = UIAlertAction(title: "삭제", style: .destructive) { _ in self.deleteAction() }
        let cancelAlertAction = UIAlertAction(title: "취소", style: .cancel)
        
        moreAlert.addAction(writeAlertAction)
        moreAlert.addAction(deleteAlertAction)
        moreAlert.addAction(cancelAlertAction)
        
        self.present(moreAlert, animated: true)
    }
    
    @objc func writeAction() {
        if let postNo = postNo {
            coordinator?.showEditFeed(postNo: postNo)
        }
    }
    
    @objc func deleteAction() {
        let deleteAlert = UIAlertController(
            title: "기록 삭제",
            message: "삭제된 기록은 다시 불러올 수 없습니다.\n해당 기록을 삭제하시겠습니까?",
            preferredStyle: .alert
        )
        let confirm = UIAlertAction(title: "삭제", style: .destructive) { _ in
            if let reactor = self.reactor, let postNo = self.postNo {
                reactor.action.onNext(.deleteRunningRecord(postNo))
            }
        }
        let cancel = UIAlertAction(title: "아니오", style: .default)
        deleteAlert.addAction(cancel)
        deleteAlert.addAction(confirm)
        
        self.present(deleteAlert, animated: true)
    }
}

// MARK: - Binding

extension RecordDetailViewController: View {
    
    public func bind(reactor: RecordDetailReactor) {
        bindingView(reactor: reactor)
        bindingState(reactor: reactor)
        bindingButtonAction(reactor: reactor)
    }
    
    private func bindingView(reactor: RecordDetailReactor) {
        rx.viewDidLoad
            .bind { [weak self] _ in
                guard let self = self, let postNo = postNo else {return}
                reactor.action.onNext(.fetchRecordDetailData(postNo))
            }
            .disposed(by: disposeBag)
        
        self.runningResultView.recordView.tableView.rx.observe(CGSize.self, "contentSize")
            .bind{ [weak self] size in
                guard let size = size, let self = self else {return}
                self.runningResultView.recordView.tableView.snp.updateConstraints { make in
                    make.height.equalTo(size.height)
                }
            }.disposed(by: self.disposeBag)
    }
    
    private func bindingState(reactor: RecordDetailReactor) {
        reactor.state
            .compactMap{$0.runningResult}
            .bind{ [weak self] runningResult in
                guard let self = self else { return }
                self.runningResultView.setData(runningModel: runningResult)
                self.runningResultView.mapArea.mapView.configureMap(runningResult: runningResult)
            }.disposed(by: self.disposeBag)
        
        reactor.state
            .compactMap {$0.runningResult}
            .map { self.calculateTotalRunningTimePerKm(runningResult: $0) }
            .bind(to: runningResultView.recordView.tableView.rx.items(cellIdentifier: RunningResultRecordTableViewCell.identifier, cellType: RunningResultRecordTableViewCell.self)) { index, model, cell in
                cell.setData(distance: model.key, time: Int(model.value.runningTime))
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .filter {$0.isFinishDeleteRunningRecord}
            .bind{ [weak self] runningResult in
                guard let self = self else { return }
                self.tabBarController?.tabBar.isHidden = false
                self.navigationController?.popViewController(animated: true)
            }.disposed(by: self.disposeBag)
    }
    
    private func bindingButtonAction(reactor: RecordDetailReactor) {
        let tapGesture = UITapGestureRecognizer()
        self.runningResultView.mapArea.mapView.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(showMapView))
    }
    
    //MARK: - Helpers
    
    @objc func showMapView() {
        if let runningResult = reactor?.currentState.runningResult {
            let mapVC = RunningMapViewController(runningResult: runningResult)
            self.navigationController?.pushViewController(mapVC, animated: true)
        }
    }
    
    func calculateTotalRunningTimePerKm(runningResult: RunningResult) -> Array<(key: Double, value: RouteInfo)> {
        let groupedByDistance = Dictionary(grouping: runningResult.routeList) { Int($0.distance) }
        var routeInfoPerKm: [Double: RouteInfo] = [:]

        for (km, values) in groupedByDistance {
            if let routeInfo = values.max(by: { $0.timestamp < $1.timestamp }) {
                routeInfoPerKm[Double(km)] = routeInfo
            }
        }

        let routes = routeInfoPerKm.sorted { $0.key < $1.key }
        return routes
    }
}
