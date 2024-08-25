//
//  SignOutTableViewCell.swift
//  Presentation
//
//  Created by 유현진 on 8/24/24.
//

import UIKit
import SnapKit
import Common

class SignOutTableViewCell: UITableViewCell {
    
    static let identifier: String = "signOutCell"
    
    private lazy var isCheck: Bool = false{
        didSet{
            checkBoxButton.isSelected = isCheck
        }
    }

    private lazy var checkBoxButton: UIButton = {
        let button = UIButton()
        button.setImage(CommonAsset.checkBoxFalse.image, for: .normal)
        button.setImage(CommonAsset.checkBoxTrue.image, for: .selected)
        return button
    }()
    
    private lazy var reasonLabel: UILabel = {
        let label = UILabel()
        label.font = .Body1Regular
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reasonLabel.text = ""
        self.isCheck = false
    }
    
    private func configureUI(){
        self.selectionStyle = .none
        
        [checkBoxButton, reasonLabel].forEach {
            self.contentView.addSubview($0)
        }
        
        checkBoxButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        reasonLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalTo(checkBoxButton.snp.right).offset(20)
            make.right.lessThanOrEqualToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    func configureModel(reasonModel: SignOutReasonCase, isChecked: Bool){
        reasonLabel.text = reasonModel.title
        isCheck = isChecked
    }
}
