//
//  RunningPopupView.swift
//  Presentation
//
//  Created by najin on 7/2/24.
//

import UIKit
import SnapKit

class RunningPopupView: UIView {
    
    var tabBarHeight = 0.0
    
    lazy var freeRunningButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("자유러닝", for: .normal)
        button.tintColor = .black
        button.layer.cornerRadius = 24
//        button.backgroundColor = .Secondary100
        button.backgroundColor = .Primary
        button.titleLabel?.font = .Body1Regular
        return button
    }()
    
    lazy var myRunningButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("목표러닝", for: .normal)
        button.tintColor = .black
        button.layer.cornerRadius = 24
//        button.backgroundColor = .Secondary100
        button.backgroundColor = .Primary
        button.titleLabel?.font = .Body1Regular
        return button
    }()
    
    lazy var popupStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
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
    
    private func setupViews() {
        addSubview(popupStackView)
        popupStackView.addArrangedSubview(freeRunningButton)
        popupStackView.addArrangedSubview(myRunningButton)
    }
    
    private func setupConstraints() {
        popupStackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(tabBarHeight + 10)
            make.leading.right.equalToSuperview().inset(20)
            make.height.equalTo(130)
        }
    }
}
