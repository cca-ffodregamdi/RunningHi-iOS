//
//  EditFeedViewController.swift
//  Presentation
//
//  Created by 유현진 on 6/26/24.
//

import UIKit
import RxSwift
import ReactorKit
import RxRelay
import Domain
import CoreLocation
import PhotosUI
import Common

public enum EditFeedEnterType {
    case feed
    case record
    case running
}

public protocol EditFeedViewControllerDelegate: AnyObject{
    func updateFeedDetail()
}

final public class EditFeedViewController: UIViewController {
    
    //MARK: - Properties
    
    public var coordinator: FeedCoordinatorInterface?
    
    public weak var delegate: EditFeedViewControllerDelegate?
    
    public var disposeBag = DisposeBag()
    
    private lazy var feedEditView: FeedEditView = {
        return FeedEditView()
    }()
    
    //MARK: - Lifecycle
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(reactor: EditFeedReactor){
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    deinit {
        print("deinit EditFeedViewController")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureUI()
    }
    
    //MARK: - Configure
    
    private func configureNavigationBar() {
        self.title = "새 게시글"
        self.navigationController?.navigationBar.tintColor = .black
        
        let backButton: UIButton = UIButton(type: .custom)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.addTarget(self, action: #selector(customBackAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completeAction))
        self.navigationItem.rightBarButtonItem?.tintColor = .Neutrals300
    }
    
    private func configureUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(feedEditView)
        
        feedEditView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - Helpers
    
    @objc func customBackAction() {
        if reactor?.currentState.enterType == .running {
            self.navigationController?.isNavigationBarHidden = true
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func completeAction() {
        if feedEditView.contentTextView.text == "" || reactor?.currentState.representType == nil {
            return
        }
        
        if let postNo = reactor?.currentState.postNo {
            reactor?.action.onNext(.createRunningFeed(EditFeedModel(postNo: postNo,
                                                                    postContent: feedEditView.contentTextView.text,
                                                                    mainData: reactor?.currentState.representType ?? .none,
                                                                    imageUrl: "")))
        }
    }
}

// MARK: - Binding

extension EditFeedViewController: View {
    
    public func bind(reactor: EditFeedReactor) {
        bindingView(reactor: reactor)
        bindingButtonAction(reactor: reactor)
    }
    
    private func bindingView(reactor: EditFeedReactor) {
        reactor.state
            .compactMap{$0.isFinishCreateRunningFeed}
            .distinctUntilChanged()
            .bind{ [weak self] type in
                guard let self = self else { return }
                
                switch reactor.currentState.enterType {
                case .feed:
                    self.delegate?.updateFeedDetail()
                    self.navigationController?.popViewController(animated: true)
                case .record:
                    self.tabBarController?.tabBar.isHidden = false
                    self.navigationController?.popToRootViewController(animated: true)
                case .running:
                    self.navigationController?.isNavigationBarHidden = true
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }.disposed(by: self.disposeBag)
        
        Observable.combineLatest(feedEditView.contentTextView.rx.text, reactor.state.map { $0.representType })
            .subscribe(onNext: { [weak self] text, representType in
                guard let self = self else { return }
                
                if text == "" || representType == nil {
                    self.navigationItem.rightBarButtonItem?.tintColor = .Neutrals300
//                    self.navigationItem.rightBarButtonItem?.isEnabled = false
                } else {
                    self.navigationItem.rightBarButtonItem?.tintColor = .Primary
//                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap{$0.representType}
            .distinctUntilChanged()
            .bind{ [weak self] type in
                guard let self = self else { return }
                feedEditView.setRepresentType(type: type)
            }.disposed(by: self.disposeBag)
    }
    
    private func bindingButtonAction(reactor: EditFeedReactor) {
        let represent1Tap = feedEditView.representDistanceButton.rx.tap
            .map { Reactor.Action.tapRepresentButton(.distance) }

        let represent2Tap = feedEditView.representTimeButton.rx.tap
            .map { Reactor.Action.tapRepresentButton(.time) }
        
        let represent3Tap = feedEditView.representPaceButton.rx.tap
            .map { Reactor.Action.tapRepresentButton(.pace) }
        
        let represent4Tap = feedEditView.representKcalButton.rx.tap
            .map { Reactor.Action.tapRepresentButton(.kcal) }
        
        let represent5Tap = feedEditView.representNoneButton.rx.tap
            .map { Reactor.Action.tapRepresentButton(.none) }

        Observable.merge(represent1Tap, represent2Tap, represent3Tap, represent4Tap, represent5Tap)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // 러닝 이미지 첨부
        let tapGesture = UITapGestureRecognizer()
        feedEditView.runningImageView.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(showProfileImageActionSheet))
    }
    
    //MARK: - Helpers
    
    @objc func showProfileImageActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        let showCamera = UIAlertAction(title: "카메라 촬영", style: .default) { [weak self] _ in
//            guard let self = self else { return }
//            self.showCamera()
//        }
        let showAlbum = UIAlertAction(title: "앨범에서 선택", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.showAlbum()
        }
        let deleteProfileImage = UIAlertAction(title: "사진 제거", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.feedEditView.runningImageView.image = CommonAsset.defaultLargeProfile.image
            self.reactor?.action.onNext(.selectedImage(nil))
        }
        let cancel = UIAlertAction(title: "닫기", style: .cancel)
//        actionSheet.addAction(showCamera)
        actionSheet.addAction(showAlbum)
        actionSheet.addAction(deleteProfileImage)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true)
    }
}

extension EditFeedViewController: PHPickerViewControllerDelegate {
    
    public func showAlbum(){
        var configuration = PHPickerConfiguration()
        configuration.filter = .any(of: [.images])
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self){
            itemProvider.loadObject(ofClass: UIImage.self) { (imageData, error) in
                DispatchQueue.main.async { [weak self] in
                    if let image = imageData as? UIImage{
                        self?.feedEditView.runningImageView.image = image
                        if let jpegImage = image.jpegData(compressionQuality: 0.8){
                            self?.reactor?.action.onNext(.selectedImage(jpegImage))
                        }
                    }
                }
            }
        }
        
        picker.dismiss(animated: true)
    }
}

//extension EditFeedViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    public func showCamera() {
//        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
//            print("카메라를 사용할 수 없습니다.")
//            return
//        }
//
//        let cameraPicker = UIImagePickerController()
//        cameraPicker.sourceType = .camera
//        cameraPicker.delegate = self
//        present(cameraPicker, animated: true, completion: nil)
//    }
//
//    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true, completion: nil)
//
//        if let image = info[.originalImage] as? UIImage {
//            // 촬영한 이미지 처리
//        }
//    }
//
//    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
//}
