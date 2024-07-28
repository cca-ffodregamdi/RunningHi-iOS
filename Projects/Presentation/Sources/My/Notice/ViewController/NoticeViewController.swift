//
//  NoticeViewController.swift
//  Presentation
//
//  Created by 유현진 on 7/15/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import ReactorKit

public class NoticeViewController: UIViewController {

    public var disposeBag: DisposeBag = DisposeBag()
    
    public var coordinator: MyCoordinatorInterface?
    
    private lazy var noticeView: NoticeView = {
        return NoticeView()
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationBar()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    public init(reactor: NoticeReactor){
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureNavigationBar(){
        self.navigationController?.navigationBar.tintColor = .black
        self.title = "공지사항"
    }
    
    private func configureUI(){
        self.view.addSubview(noticeView)
        noticeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension NoticeViewController: View{

    public func bind(reactor: NoticeReactor) {
        reactor.action.onNext(.fetchNotice)
        
        reactor.state.map{$0.notices}
            .bind(to: self.noticeView.noticeTableView.rx.items(cellIdentifier: "noticeCell", cellType: NoticeTableViewCell.self)){ index, model, cell in
                cell.configureModel(noticeModel: model)
            }.disposed(by: self.disposeBag)
        
        self.noticeView.noticeTableView.rx.observe(CGSize.self, "contentSize")
            .bind{ [weak self] size in
                guard let size = size, let self = self else {return}
                self.noticeView.noticeTableView.snp.updateConstraints { make in
                    make.height.equalTo(size.height)
                }
            }.disposed(by: self.disposeBag)
        
        self.noticeView.noticeTableView.rx.itemSelected
            .bind{ [weak self] indexPath in
                guard let self = self else { return }
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
                self.coordinator?.showNoticeDetail(noticeModel: reactor.currentState.notices[indexPath.row])
            }.disposed(by: self.disposeBag)
    }
}

