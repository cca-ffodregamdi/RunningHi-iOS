//
//  RunningResultViewController.swift
//  Presentation
//
//  Created by najin on 7/7/24.
//

import UIKit
import RxCocoa
import RxSwift
import ReactorKit
import RxRelay
import RxDataSources
import Domain

final public class RunningResultViewController: UIViewController {
    
    //MARK: - Properties
    
    public var coordinator: RunningCoordinatorInterface?
    
    public var runningModel: RunningModel?
    public var disposeBag = DisposeBag()
    
    private var runningResultView: RunningResultView = {
        return RunningResultView()
    }()
    
    //MARK: - Lifecycle
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit RunningResultViewController")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNavigationBar()
        
        print(runningModel)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: - Configure
    
    private func configureUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(runningResultView)
        
        runningResultView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func configureNavigationBar(){
        self.title = "러닝 기록"
        self.navigationController?.navigationBar.tintColor = .black
        
        let backButton: UIButton = UIButton(type: .custom)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.addTarget(self, action: #selector(customBackAction), for: .touchUpInside)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "삭제", style: .plain, target: self, action: #selector(deleteAction))
    }
    
    //MARK: - Helpers
    
    @objc func customBackAction() {
        coordinator?.finishRunning()
    }
    
    @objc func deleteAction() {
    }
}

// MARK: - Binding

extension RunningResultViewController: View {
    
    public func bind(reactor: RunningReactor) {
        binding(reactor: reactor)
    }
    
    private func binding(reactor: RunningReactor) {
        Observable<[Int]>.just([1,2,3,4,5])
            .bind(to: runningResultView.recordView.tableView.rx.items(cellIdentifier: RunningResultRecordTableViewCell.identifier, cellType: RunningResultRecordTableViewCell.self)) { index, model, cell in
                cell.setData(distance: 0, averagePace: 0, calorie: 0)
                
                // 마지막줄 라인 제거
                if index == 4 {
                    cell.removeLine()
                }
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
}
