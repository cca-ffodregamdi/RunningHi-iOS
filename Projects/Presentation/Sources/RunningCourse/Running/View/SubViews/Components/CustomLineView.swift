//
//  CustomLineView.swift
//  Presentation
//
//  Created by najin on 7/7/24.
//

import UIKit
import SnapKit

class CustomLineView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLine()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLine()
    }
    
    //MARK: - Configure
    
    private func setupLine() {
        let lineView = UIView()
        lineView.backgroundColor = .Neutrals100
        
        addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.edges.equalToSuperview()
        }
    }
}
