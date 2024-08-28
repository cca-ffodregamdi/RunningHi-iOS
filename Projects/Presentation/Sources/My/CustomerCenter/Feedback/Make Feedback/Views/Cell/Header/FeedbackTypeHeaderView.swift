//
//  FeedbackTypeHeaderView.swift
//  Presentation
//
//  Created by 유현진 on 8/28/24.
//

import UIKit
import Common
import SnapKit
import RxSwift

class FeedbackTypeHeaderView: UITableViewHeaderFooterView {

    static let identifier: String = "feedbackTypeHeaderView"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .Body1Regular
        label.textColor = .Neutrals500
        label.text = "카테고리 선택"
        return label
    }()
    
    private lazy var updownImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.chevronUpOutline.image.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .Neutrals300
        return imageView
    }()
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        return UITapGestureRecognizer()
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureUI()
        addTapGestureRecognizer()
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func configureUI(){
        
        self.addSubview(titleLabel)
        self.addSubview(updownImageView)
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(16)
        }
        
        updownImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
    }

    private func addTapGestureRecognizer(){
        self.addGestureRecognizer(tapGestureRecognizer)
    }
}
