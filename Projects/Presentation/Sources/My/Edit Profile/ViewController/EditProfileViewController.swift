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
import PhotosUI

public protocol EditProfileViewControllerDelegate: AnyObject{
    func editProfile()
}

public class EditProfileViewController: UIViewController {
    
    public var disposeBag: DisposeBag = DisposeBag()
    
    public var coordinator: MyCoordinatorInterface?
    
    public weak var delegate: EditProfileViewControllerDelegate?
    
    private lazy var editProfileView: EditProfileView = {
        return EditProfileView()
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationBar()
        hideKeyboardWhenTouchUpBackground()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.view.endEditing(true)
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem!.tintColor = .Primary
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
    
    private func showProfileImageActionSheet(){
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let showAlbum = UIAlertAction(title: "앨범에서 선택", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.showAlbum()
        }
        let deleteProfileImage = UIAlertAction(title: "프로필 사진 삭제", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.editProfileView.profileImageView.image = CommonAsset.defaultLargeProfile.image
            self.reactor?.action.onNext(.deleteImage)
        }
        let cancel = UIAlertAction(title: "닫기", style: .cancel)
        actionSheet.addAction(showAlbum)
        actionSheet.addAction(deleteProfileImage)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true)
    }
}
extension EditProfileViewController: View{
    public func bind(reactor: EditProfileReactor) {
        
        reactor.action.onNext(.fetchUserInfo)
        
        reactor.state.compactMap{$0.userInfo}
            .map{$0.nickname}
            .bind(to: editProfileView.nicknameTextField.rx.placeholder)
            .disposed(by: self.disposeBag)
        
        reactor.state.compactMap{$0.userInfo}
            .compactMap{$0.profileImageUrl}
            .take(1)
            .bind{ [weak self] in
                guard let self = self else { return }
                self.editProfileView.profileImageView.setImage(urlString: $0)
            }.disposed(by: self.disposeBag)
        
        configureNavigationBarItem()
        
        editProfileView.nicknameTextField.rx.text
            .compactMap{$0}
            .map{ !$0.isEmpty }
            .map{Reactor.Action.changeNickname($0)}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        editProfileView.nicknameTextField.rx.text
            .map{Reactor.Action.updateNickname($0)}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        Observable.combineLatest(reactor.state.map{$0.isChangedNickname},
                                  reactor.state.map{$0.isChangedProfileImage},
                                 reactor.state.map{$0.isDeleteProfileImage})
        .map{$0 || $1 || $2}
        .bind(to: self.navigationItem.rightBarButtonItem!.rx.isEnabled)
        .disposed(by: self.disposeBag)
        
        self.navigationItem.rightBarButtonItem!.rx
            .tap
            .map{Reactor.Action.editProfile}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        editProfileView.nicknameTextField.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext:{ [weak self] in
                guard let self = self else { return }
                self.editProfileView.nicknameTextField.layer.borderColor = UIColor.Primary.cgColor
            }).disposed(by: self.disposeBag)
        
        editProfileView.nicknameTextField.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext:{ [weak self] in
                guard let self = self else { return }
                self.editProfileView.nicknameTextField.layer.borderColor = UIColor.Neutrals500.cgColor
            }).disposed(by: self.disposeBag)
        
        editProfileView.profileImageButton.rx.tap
            .bind{ [weak self] in
                guard let self = self else { return }
                self.showProfileImageActionSheet()
            }.disposed(by: self.disposeBag)
        
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
        
        reactor.state.map{$0.successedEditProfile}
            .distinctUntilChanged()
            .filter{$0}
            .subscribe(onNext:{ [weak self] _ in
                guard let self = self else { return }
                self.delegate?.editProfile()
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: self.disposeBag)
    }
}
extension EditProfileViewController: PHPickerViewControllerDelegate {
    
    func showAlbum(){
        var configuration = PHPickerConfiguration()
        configuration.filter = .any(of: [.images])
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true) // 1
        
        let itemProvider = results.first?.itemProvider // 2
        
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self){
            itemProvider.loadObject(ofClass: UIImage.self) { (imageData, error) in
                DispatchQueue.main.async { [weak self] in
                    if let image = imageData as? UIImage{
                        self?.editProfileView.profileImageView.image = image
                        if let jpegImage = image.jpegData(compressionQuality: 0.8){
                            self?.reactor?.action.onNext(.selectedImage(jpegImage))
                        }else{
                            print("failed convert jpegData")
                        }
                    }
                }
            }
        }else{
            
        }
    }
}
