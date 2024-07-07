//
//  RunningView.swift
//  Presentation
//
//  Created by najin on 7/7/24.
//

import UIKit
import SnapKit

class RunningView: UIView {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "러닝중"
        return label
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
    
    private func setupViews() {
        addSubview(label)
    }
    
    private func setupConstraints() {
        label.snp.makeConstraints { make in
            make.edges.centerX.centerY.equalToSuperview()
        }
    }
}
