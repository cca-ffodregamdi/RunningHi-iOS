//
//  FeedRepresentButton.swift
//  Presentation
//
//  Created by najin on 8/25/24.
//

import UIKit
import Common

class FeedRepresentButton: UIButton {

    //MARK: - Properties
    
//    static var width = 66
    
    private var toggleButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.checkBoxFalse.image
        return imageView
    }()
    
    private var textLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .Body2Regular
        return label
    }()
    
    //MARK: - Lifecycle
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    required init(title: String) {
        super.init(frame: .zero)
        
        textLabel.text = title
        
        configureUI()
    }
    
    required init() {
        super.init(frame: .zero)
    }
    
    //MARK: - Configure
    
    private func configureUI() {
        addSubview(toggleButton)
        addSubview(textLabel)
        
        toggleButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        textLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerY.equalToSuperview()
            make.left.equalTo(toggleButton.snp.right).offset(8)
            make.right.equalToSuperview().offset(16)
        }
    }
    
    //MARK: - Helpers
    
    func setActiveButton(isActive: Bool) {
        toggleButton.image = isActive ? CommonAsset.checkBoxTrue.image : CommonAsset.checkBoxFalse.image
    }
}
