//
//  LoginViewController.swift
//  Presentation
//
//  Created by 유현진 on 5/3/24.
//

import UIKit
import RxCocoa
import ReactorKit
import SnapKit

protocol LoginViewControllerDelegate: AnyObject{
    func login()
}

final class LoginViewController: UIViewController {
    
    // MARK: Properties
    
    var disposeBag: DisposeBag = DisposeBag()
    
    weak var delegate: LoginViewControllerDelegate?
    
    private lazy var loginView: LoginView = {
        return LoginView()
    }()
    
    init(){
        super.init(nibName: nil, bundle: nil)   
        self.reactor = LoginReactor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        print("deinit LoginViewController")
    }
    
    // MARK: Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    
    func configureUI(){
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(loginView)
        
        loginView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}


extension LoginViewController: View{
    func bind(reactor: LoginReactor){
        loginView.kakaoLoginButton.rx.tap
            .map{ Reactor.Action.login }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map{$0.testLogin}
            .distinctUntilChanged()
            .bind{ [weak self] isLogin in
                if isLogin{
                    self?.delegate?.login()
                }
            }.disposed(by: self.disposeBag)
        
        reactor.state
            .map{$0.isLoading}
            .distinctUntilChanged()
            .bind{ isLoading in
                // TODO: activityIndicator
            }.disposed(by: self.disposeBag)
    }
}
