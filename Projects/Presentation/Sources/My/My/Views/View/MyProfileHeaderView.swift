//
//  MyProfileHeaderView.swift
//  Presentation
//
//  Created by 유현진 on 5/17/24.
//

import UIKit
import Common
import SnapKit

class MyProfileHeaderView: UIView{
    
    lazy var myProfileView: MyProfileView = {
        return MyProfileView()
    }()
    
    lazy var myLevelView: MyLevelView = {
        return MyLevelView()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.backgroundColor = .clear
        
        self.addSubview(myProfileView)
        self.addSubview(myLevelView)
        
        myProfileView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        myLevelView.snp.makeConstraints { make in
            make.top.equalTo(myProfileView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(30)
        }
        
    }
}
