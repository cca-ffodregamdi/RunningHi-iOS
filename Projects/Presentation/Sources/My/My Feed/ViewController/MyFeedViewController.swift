//
//  MyFeedViewController.swift
//  Presentation
//
//  Created by 유현진 on 7/27/24.
//

import UIKit
import SnapKit

final public class MyFeedViewController: UIViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
}
