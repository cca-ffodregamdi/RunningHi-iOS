//
//  StickyImageView.swift
//  Common
//
//  Created by 유현진 on 6/26/24.
//

import UIKit
import Kingfisher

public class StickyImageView: UIImageView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        self.backgroundColor = UIColor.lightGray // 이미지 로딩 중 표시할 색상 설정
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(url: URL) {
        self.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.2))]) // Kingfisher를 사용하여 이미지 설정
    }
}
