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
import Domain

public protocol LoginViewControllerDelegate: AnyObject{
    func login()
}

final public class LoginViewController: UIViewController {
    
    // MARK: Properties
    
    public var disposeBag: DisposeBag = DisposeBag()
    
    weak var delegate: LoginViewControllerDelegate?
    
    public var coordinator: LoginCoordinatorInterface?
    
    private lazy var loginView: LoginView = {
        return LoginView()
    }()
    
    public init(reactor: LoginReactor){
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        print("deinit LoginViewController")
    }
    
    // MARK: Lifecycles
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    
    func configureUI(){
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(loginView)
        
        loginView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}


extension LoginViewController: View{
    public func bind(reactor: LoginReactor){
        loginView.kakaoLoginButton.rx.tap
            .map{ Reactor.Action.kakaoLogin }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        loginView.appleLoginButton.rx.tap
            .map{ Reactor.Action.appleLogin }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map{$0.successed}
            .distinctUntilChanged()
            .bind{ [weak self] isLogin in
                if isLogin{
                    self?.coordinator?.login()
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
