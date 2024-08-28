//
//  AnnounceViewController.swift
//  Presentation
//
//  Created by 유현진 on 8/5/24.
//

import UIKit
import RxSwift
import ReactorKit
import SnapKit
import RxCocoa

public class AnnounceViewController: UIViewController {

    public var disposeBag: DisposeBag = DisposeBag()
    
    private lazy var announceView: AnnounceView = {
        return AnnounceView()
    }()
    
    public init(reactor: AnnounceReactor){
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigation()
    }
    
    private func configureNavigation(){
        self.title = "알림"
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    private func configureUI(){
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(announceView)
        
        announceView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
    }
}

extension AnnounceViewController: View{
    public func bind(reactor: AnnounceReactor) {
        reactor.action.onNext(.fetchAnnounce)
        
        reactor.state.map{$0.announces}
            .bind(to: announceView.announceTableView.rx.items(cellIdentifier: AnnounceTableViewCell.identifier, cellType: AnnounceTableViewCell.self)){ index, item, cell in
                cell.configureModel(model: item)
                
                cell.deleteButton.rx.tap
                    .map{ Reactor.Action.deleteAnnounce(announceId: item.announceId, index: index)}
                    .bind(to: reactor.action)
                    .disposed(by: cell.disposeBag)
            }.disposed(by: self.disposeBag)
    }
}
