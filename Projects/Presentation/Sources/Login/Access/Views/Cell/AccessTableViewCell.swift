//
//  AccessTableViewCell.swift
//  Presentation
//
//  Created by 유현진 on 8/7/24.
//

import UIKit
import Common
import SnapKit
import RxSwift

class AccessTableViewCell: UITableViewCell {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    static let identifier: String = "accessCell"
    
    lazy var checkButton: UIButton = {
        let button = UIButton()
        button.setImage(CommonAsset.checkboxSquareFalse.image, for: .normal)
        button.setImage(CommonAsset.checkboxSquareTrue.image, for: .selected)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .Body1Regular
        label.textColor = .black
        return label
    }()
    
    private lazy var chevronRightButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.chevronRightOutline.image
        return imageView
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func configureUI(){
        self.selectionStyle = .none
        
        [checkButton,
        titleLabel,
         chevronRightButton].forEach{
            self.contentView.addSubview($0)
        }
        
        checkButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.left.equalToSuperview().offset(12)
            make.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.left.equalTo(checkButton.snp.right).offset(10)
            make.right.lessThanOrEqualTo(chevronRightButton.snp.left).offset(-20)
        }
        
        chevronRightButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.right.equalToSuperview()
            make.width.height.equalTo(24)
        }
    }
    
    func configureModel(title: String){
        self.titleLabel.text = title
    }
}
