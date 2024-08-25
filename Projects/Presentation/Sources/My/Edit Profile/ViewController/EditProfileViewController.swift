//
//  EditProfileViewController.swift
//  Presentation
//
//  Created by 유현진 on 8/23/24.
//

import UIKit
import Common
import RxSwift
import RxCocoa
import ReactorKit
import SnapKit

public class EditProfileViewController: UIViewController {

    public var disposeBag: DisposeBag = DisposeBag()
    
    public var coordinator: MyCoordinatorInterface?
    
    private lazy var editProfileView: EditProfileView = {
        return EditProfileView()
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.Neutrals300, for: .disabled)
        button.setTitleColor(.Primary, for: .normal)
        button.titleLabel?.font = .Body1Regular
        return button
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationBar()
        configureNavigationBarItem()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    public init(reactor: EditProfileReactor){
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.view.backgroundColor = .Secondary100
        self.view.addSubview(editProfileView)
        
        editProfileView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
    }
    
    private func configureNavigationBar(){
        self.title = "내 정보 수정"
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    private func configureNavigationBarItem(){
        var barButtonItems: [UIBarButtonItem] = []
        barButtonItems.append(UIBarButtonItem(customView: confirmButton))
        self.navigationItem.setRightBarButtonItems(barButtonItems, animated: false)
    }
    
    private func showLogoutAlert(){
        let alertView = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        
        let logout = UIAlertAction(title: "로그아웃", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            reactor?.action.onNext(.logout)
        }
        
        let cancel = UIAlertAction(title: "아니오", style: .cancel)
        alertView.addAction(cancel)
        alertView.addAction(logout)
        self.present(alertView, animated: true)
    }
    
    private func showSignOutAlert(){
        let alertView = UIAlertController(title: "회원 탈퇴", message: "정말 회원 탈퇴 하시겠습니까?", preferredStyle: .alert)
        
        let logout = UIAlertAction(title: "탈퇴", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.showSuccessedSignOutAlert()
        }
        
        let cancel = UIAlertAction(title: "아니오", style: .cancel)
        alertView.addAction(cancel)
        alertView.addAction(logout)
        self.present(alertView, animated: true)
    }
    
    private func showSuccessedSignOutAlert(){
        let alertView = UIAlertController(title: "회원 탈퇴가 완료되었습니다.", message: "그동안 함께 달려온 추억, 잊지 않을게요! 언제든 다시 만나요!", preferredStyle: .alert)
        
        let dismiss = UIAlertAction(title: "메인으로 돌아가기", style: .default) { [weak self] _ in
            guard let self = self else { return }
            reactor?.action.onNext(.signOut)
        }
        alertView.addAction(dismiss)
        self.present(alertView, animated: true)
    }
}
extension EditProfileViewController: View{
    public func bind(reactor: EditProfileReactor) {
        
        editProfileView.logoutButton.rx.tap
            .bind{ [weak self] _ in
                guard let self = self else { return }
                self.showLogoutAlert()
            }.disposed(by: self.disposeBag)
        
        editProfileView.signOutButton.rx.tap
            .bind{ [weak self] _ in
                guard let self = self else { return }
                self.showSignOutAlert()
            }.disposed(by: self.disposeBag)
        
        reactor.state.map{$0.isLogout}
            .filter{$0}
            .distinctUntilChanged()
            .bind{ [weak self] _ in
                guard let self = self else { return }
                self.coordinator?.backLogin()
            }.disposed(by: self.disposeBag)
        
        reactor.state.map{$0.isSignOut}
            .filter{$0}
            .distinctUntilChanged()
            .bind{ [weak self] _ in
                guard let self = self else { return }
                self.coordinator?.backLogin()
            }.disposed(by: self.disposeBag)
    }
}
