//
//  ReviewerLoginViewController.swift
//  Presentation
//
//  Created by najin on 9/5/24.
//

import UIKit
import RxCocoa
import ReactorKit
import SnapKit
import Domain


final public class ReviewerLoginViewController: UIViewController {
    
    // MARK: Properties
    
    public var disposeBag: DisposeBag = DisposeBag()
    
    public var coordinator: LoginCoordinatorInterface?
    
    private lazy var loginView: ReviewerLoginView = {
        return ReviewerLoginView()
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

extension ReviewerLoginViewController: View {
    public func bind(reactor: LoginReactor) {
        loginView.loginButton.rx.tap
            .bind{ [weak self] _ in
                guard let self = self else { return }
                
                if loginView.idTextField.text == "runningHi123" && loginView.passwordTextField.text == "running3355!@#" {
                    reactor.action.onNext(.reviewerLogin)
                } else {
                    showLoginPopup()
                }
            }.disposed(by: self.disposeBag)
        
        reactor.state
            .map{$0.successed}
            .distinctUntilChanged()
            .filter{$0}
            .bind{ [weak self] _ in
                guard let self = self else { return }
                coordinator?.successedSignIn()
            }.disposed(by: self.disposeBag)
    }
    
    // MARK: - Helper
    
    func showLoginPopup() {
        let alertView = UIAlertController(title: "로그인", message: "아이디 또는 비밀번호가 맞지 않습니다.", preferredStyle: .alert)
        let button = UIAlertAction(title: "확인", style: .default)
        alertView.addAction(button)
        self.present(alertView, animated: true)
    }
}
