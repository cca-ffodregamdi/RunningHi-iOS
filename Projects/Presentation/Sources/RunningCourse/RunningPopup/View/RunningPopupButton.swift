//
//  RunningPopupButton.swift
//  Presentation
//
//  Created by najin on 7/7/24.
//

import UIKit

class RunningPopupButton: UIButton {
    
    //MARK: - Properties
    
    private var textLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .Body1Regular
        return label
    }()

    //MARK: - Lifecycle
    
    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        textLabel.text = title
        
        configureUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Configure
    
    private func configureUI() {
        self.layer.cornerRadius = 24
        self.backgroundColor = .Secondary100
        self.titleLabel?.font = .Body1Regular
        self.setTitleColor(.black, for: .normal)
        
        addSubview(textLabel)
        
        textLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.left.equalToSuperview().offset(24)
        }
    }
}
