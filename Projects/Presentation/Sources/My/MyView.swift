//
//  MyView.swift
//  Presentation
//
//  Created by 유현진 on 5/17/24.
//

import UIKit

class MyView: UIView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.backgroundColor = .systemBackground
    }
    
}
