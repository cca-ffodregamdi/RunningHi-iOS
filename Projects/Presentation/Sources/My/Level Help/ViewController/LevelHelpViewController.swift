//
//  LevelHelpViewController.swift
//  Presentation
//
//  Created by 유현진 on 8/19/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

public class LevelHelpViewController: UIViewController {
    
    private let customTransitioningDelegate: CustomTransitioningDelegate
    
    private var disposeBag: DisposeBag = DisposeBag()
    
    private lazy var levelHelpView: LevelHelpView = {
        return LevelHelpView()
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    public init(){
        customTransitioningDelegate = CustomTransitioningDelegate(modalHeight: 280)
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = customTransitioningDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.view.addSubview(levelHelpView)
        
        levelHelpView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func bind(){
        levelHelpView.cancelButton.rx.tap
            .bind{ [weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: true)
            }.disposed(by: self.disposeBag)
    }
}
