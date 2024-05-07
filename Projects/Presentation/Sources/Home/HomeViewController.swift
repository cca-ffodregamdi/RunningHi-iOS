//
//  HomeViewController.swift
//  Presentation
//
//  Created by 유현진 on 5/3/24.
//

import UIKit


protocol HomeViewControllerDelegate{
    func logout()
}

class HomeViewController: UIViewController {

    var delegate: HomeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .orange
        let item = UIBarButtonItem(title: "로그아웃", style: .plain, target: self, action: #selector(self.logout))
        self.navigationItem.rightBarButtonItem = item
    }
    
    deinit{
        print("deinit HomeViewController")
    }
    
    @objc private func logout(){
        self.delegate?.logout()
    }
}
