//
//  UIViewController+Extensions.swift
//  App
//
//  Created by 오영석 on 5/7/24.
//

import UIKit
import SnapKit

public extension UIViewController {
    /// logo leftBarButton
    /// -> navigationItem.configNavigationLogo() 호출
    func configNavigationLogo() {
        let logoButton = UIButton(type: .system)
        let image = UIImage(named: "logo")
        logoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        let leftItem = UIBarButtonItem(customView: logoButton)
        let height: CGFloat = 26
        leftItem.customView?.snp.makeConstraints({ make in
            make.height.equalTo(height)
            make.width.equalTo(image?.getRatio(height: height) ?? 0)
        })
        leftItem.isEnabled = false
        self.navigationItem.leftBarButtonItem = leftItem
    }
    
    /// 네비게이션 뒤로가기 버튼
    /// -> 사용방법: a에서 b로 이동한다면 a에서 선언
    func configNavigationBackButton() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        let backImage = UIImage(systemName: "chevron.left", withConfiguration: imageConfig)
        navigationController?.navigationBar.backIndicatorImage = backImage
        backImage?.accessibilityLabel = "뒤로가기"
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .blue
    }
    
    /// 네비게이션 뒤로가기 버튼 숨기기
    /// -> 사용방법: a에서 b로 이동한다면 a에서 선언
    func hideNavigationBackButton() {
        self.navigationItem.hidesBackButton = true
    }
    
    /// 네비게이션 safeArea 까지의 배경색 설정
    func configNavigationBgColor(backgroundColor: UIColor = .systemBackground) {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = backgroundColor
        navigationBarAppearance.shadowColor = .clear // 밑줄 제거
        navigationBarAppearance.shadowImage = UIImage() // 밑줄 제거
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
}
