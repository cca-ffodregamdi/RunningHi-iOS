//
//  AccessDetailViewController.swift
//  Presentation
//
//  Created by 유현진 on 8/9/24.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import SnapKit

public class AccessDetailViewController: UIViewController {

    public var disposeBag: DisposeBag = DisposeBag()
    
    private lazy var accessDetailView: AccessDetailView = {
        return AccessDetailView()
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationBar()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    public init(reactor: AccessDetailReactor){
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.view.addSubview(accessDetailView)
        self.view.backgroundColor = .systemBackground
        
        accessDetailView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    private func configureNavigationBar(){
        self.navigationController?.navigationBar.tintColor = .black
    }
}

extension AccessDetailViewController: View{
    public func bind(reactor: AccessDetailReactor) {
        
        reactor.state.map{$0.accessModels[reactor.currentState.seletedIndex]}
            .bind{ [weak self] model in
                guard let self = self else { return }
                self.accessDetailView.configureModel(model: model)
            }.disposed(by: self.disposeBag)
    }
}
