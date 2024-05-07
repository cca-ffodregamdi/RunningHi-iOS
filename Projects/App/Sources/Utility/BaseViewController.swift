//
//  BaseViewController.swift
//  App
//
//  Created by 오영석 on 5/7/24.
//

import UIKit

open class BaseViewController: UIViewController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
    }
    
    private func configUI() {
        view.configBackgroundColor()
        view.tappedDismissKeyboard()
        configNavigationBgColor()
        configNavigationBackButton()
    }
}

