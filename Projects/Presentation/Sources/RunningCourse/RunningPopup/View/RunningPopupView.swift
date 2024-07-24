//
//  RunningPopupView.swift
//  Presentation
//
//  Created by najin on 7/2/24.
//

import UIKit
import SnapKit
import Common

class RunningPopupView: UIView {
    
    //MARK: - Properties
    
    var tabBarHeight = 0.0
    
    lazy var freeRunningButton = RunningPopupButton(frame: .zero, title: "자유러닝")
    lazy var myRunningButton = RunningPopupButton(frame: .zero, title: "목표러닝")
    
    private var cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(CommonAsset.xCircle.image, for: .normal)
        return button
    }()
    
    lazy var popupStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        setupConstraints()
    }
    
    init(tabBarHeight: CGFloat) {
        super.init(frame: .zero)
        self.tabBarHeight = tabBarHeight
        
        setupViews()
        setupConstraints()
    }
    
    //MARK: - Configure
    
    private func setupViews() {
        addSubview(popupStackView)
        popupStackView.addArrangedSubview(freeRunningButton)
        popupStackView.addArrangedSubview(myRunningButton)
        
        addSubview(cancelButton)
    }
    
    private func setupConstraints() {
        popupStackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(tabBarHeight + 10)
            make.leading.right.equalToSuperview().inset(20)
            make.height.equalTo(130)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(tabBarHeight - 50)
            make.centerX.equalToSuperview()
        }
    }
}
