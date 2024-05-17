//
//  SplashViewController.swift
//  Presentation
//
//  Created by 유현진 on 5/16/24.
//

import UIKit

protocol SplashViewControllerDelegate: AnyObject{
    func pushApp()
}

class SplashViewController: UIViewController{
    
    // MARK: Properties
    
    var delegate: SplashViewControllerDelegate?
    
    private lazy var splashView: SplashView = {
        return SplashView()
    }()
    
    // MARK: Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        print("init SplashViewController")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { [weak self] in
            self?.delegate?.pushApp()
        }
    }
    
    deinit{
        print("deinit SplashViewController")
    }
    
    private func configureUI(){
        self.view.backgroundColor = UIColor(red: 34/225, green: 101/225, blue: 201/225, alpha: 1.0)
        
        self.view.addSubview(splashView)
        
        splashView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
