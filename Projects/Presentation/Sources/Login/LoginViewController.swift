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
import AuthenticationServices
import CryptoKit

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
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
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
            .bind{ [weak self] _ in
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                let request = appleIDProvider.createRequest()
                request.requestedScopes = [.fullName, .email] //유저로 부터 알 수 있는 정보들(name, email)
                
                let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                authorizationController.delegate = self
                authorizationController.presentationContextProvider = self
                authorizationController.performRequests()
            }
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
extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    
        switch authorization.credential{
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            if let authorizaionCode = appleIDCredential.authorizationCode,
               let identityToken = appleIDCredential.identityToken,
               let authCodeString = String(data: authorizaionCode, encoding: .utf8),
               let identityTokenString = String(data: identityToken, encoding: .utf8){
                print("authCodeString = \(authCodeString)")
                print("identityTokenString = \(identityTokenString)")
                
                reactor?.action.onNext(.signWithApple(SignWithApple(authorizationCode: authCodeString, identityCode: identityTokenString)))
            }
        default:
            break
        }
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        print("Error Apple Login: \(error.localizedDescription)")
    }
    
}
