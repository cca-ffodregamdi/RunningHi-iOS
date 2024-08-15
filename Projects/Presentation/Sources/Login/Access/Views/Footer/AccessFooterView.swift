//
//  AccessFooterView.swift
//  Presentation
//
//  Created by 유현진 on 8/9/24.
//

import UIKit
import SnapKit
import Common
import RxSwift

class AccessFooterView: UITableViewHeaderFooterView {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    static let identifiter: String = "accessFooterView"
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .Primary100
        view.layer.cornerRadius = 4
        return view
    }()
    
    lazy var checkButton: UIButton = {
        let button = UIButton()
        button.setImage(CommonAsset.checkboxSquareFalse.image, for: .normal)
        button.setImage(CommonAsset.checkboxSquareTrue.image, for: .selected)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .Body1Bold
        label.textColor = .Primary
        label.text = "모두 확인하였으며 동의합니다."
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .CaptionRegular
        label.textColor = .Neutrals500
        label.text = "필수 항목에 전부 동의해주셔야 회원가입이 가능합니다."
        return label
    }()
    
    lazy var tapGesture: UITapGestureRecognizer = {
        return UITapGestureRecognizer()
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureUI()
        configureGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func configureUI(){
        self.contentView.addSubview(containerView)
        
        [checkButton,
        titleLabel,
         subTitleLabel].forEach{
            self.containerView.addSubview($0)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().priority(.low)
        }
        
        checkButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(checkButton.snp.right).offset(10)
            make.top.equalToSuperview().offset(12)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalTo(checkButton.snp.right).offset(10)
            make.bottom.equalToSuperview().offset(-12)
        }
    }
    
    private func configureGesture(){
        containerView.addGestureRecognizer(tapGesture)
    }
}
