//
//  UIViewControllerExtension.swift
//  Common
//
//  Created by 유현진 on 6/12/24.
//

import UIKit

public extension UIViewController{
    func hideKeyboardWhenTouchUpBackground() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
