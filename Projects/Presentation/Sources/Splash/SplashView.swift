//
//  SplashView.swift
//  Presentation
//
//  Created by 유현진 on 5/16/24.
//

import UIKit
import SnapKit

class SplashView: UIView{
    
    private lazy var testLabel: UILabel = {
        let label = UILabel()
        label.text = "러닝하이"
        label.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    private func configureUI(){
        self.backgroundColor = UIColor(red: 34/225, green: 101/225, blue: 201/225, alpha: 1.0)
        
        self.addSubview(testLabel)
        
        testLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
