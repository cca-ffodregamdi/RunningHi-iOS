//
//  HomeViewController.swift
//  Presentation
//
//  Created by 유현진 on 5/3/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .orange
    }
    
    deinit{
        print("deinit HomeViewController")
    }
}
