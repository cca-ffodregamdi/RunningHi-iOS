//
//  MyViewController.swift
//  Presentation
//
//  Created by 유현진 on 5/17/24.
//

import UIKit
import SnapKit

class MyViewController: UIViewController{
    
    // MARK: Properties
    private lazy var myView: MyView = {
        return MyView()
    }()
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI(){
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(myView)
        myView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
    }
}
