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
    
    required init(color: UIColor = .Neutrals100, height: Int = 1) {
        super.init(frame: .zero)
        setupLine(color: color, height: height)
    }
    
    //MARK: - Configure
    
    private func setupLine(color: UIColor = .Neutrals100, height: Int = 1) {
        let lineView = UIView()
        lineView.backgroundColor = color
        
        addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.height.equalTo(height)
            make.edges.equalToSuperview()
        }
    }
}
