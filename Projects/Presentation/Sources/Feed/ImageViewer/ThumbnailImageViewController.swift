//
//  ThumbnailImageViewController.swift
//  Presentation
//
//  Created by 유현진 on 6/30/24.
//

import UIKit
import Common
import SnapKit
import RxSwift
import RxCocoa

class ThumbnailImageViewController: UIViewController {

    private var disposeBag: DisposeBag = DisposeBag()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private lazy var cancelButtonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.xOutline.image.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        return imageView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 1.0
        scrollView.bouncesZoom = true
        scrollView.backgroundColor = .black
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
        // Do any additional setup after loading the view.
    }
    
    init(imageUrl: String){
        super.init(nibName: nil, bundle: nil)
        setThumbnailImageView(imageUrl: imageUrl)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.view.addSubview(scrollView)
        scrollView.addSubview(thumbnailImageView)
        self.view.addSubview(cancelButton)
        self.cancelButton.addSubview(cancelButtonImageView)
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.left.equalToSuperview().offset(10)
            make.width.height.equalTo(45)
        }
        
        cancelButtonImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        thumbnailImageView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
    }
    
    private func setThumbnailImageView(imageUrl: String){
        self.thumbnailImageView.setImage(urlString: imageUrl)
    }

    private func bind(){
        cancelButton.rx.tap
            .bind{ [weak self] _ in
                self?.dismiss(animated: true)
            }.disposed(by: self.disposeBag)
        
        scrollView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        scrollView.rx.didScroll
            .bind{ [weak self] _ in
                guard let self = self else {return}
                guard self.scrollView.zoomScale <= 1.0 else { return }
                guard self.scrollView.zoomScale >= 3.0 else { return }
            }.disposed(by: self.disposeBag)
        
        let panGesture = UIPanGestureRecognizer()
        scrollView.addGestureRecognizer(panGesture)
    
        panGesture.rx.event
            .bind{ [weak self] gesture in
                self?.handlePanGesture(gesture: gesture)
            }.disposed(by: self.disposeBag)
    }
    
    private func handlePanGesture(gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: scrollView) // 터치한 시작 지점으로부터 이동거리
        
        switch gesture.state{
        case .changed:
            if scrollView.zoomScale == 1.0{
                if translation.y > 0 {
                    self.thumbnailImageView.center = .init(x: self.view.bounds.size.width/2, y: self.view.bounds.size.height/2 + translation.y)
                }
                if translation.y > 150 {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        case .ended, .cancelled:
            if scrollView.zoomScale == 1.0{
                UIView.animate(withDuration: 0.3) {
                    self.thumbnailImageView.center = .init(x: self.view.bounds.size.width/2, y: self.view.bounds.size.height/2)
                }
            }
        default:
            break
        }
    }
}

extension ThumbnailImageViewController: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return thumbnailImageView
    }
}
