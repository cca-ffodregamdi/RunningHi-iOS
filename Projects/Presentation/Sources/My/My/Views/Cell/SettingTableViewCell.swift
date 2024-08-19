//
//  SettingTableViewCell.swift
//  Presentation
//
//  Created by 유현진 on 5/19/24.
//

import UIKit
import SnapKit
import Common

class SettingTableViewCell: UITableViewCell {

    static let identifier: String = "MySettingCell"
    
    private lazy var typeImageView: UIImageView = {
        var imageView = UIImageView()
        return imageView
    }()
    
    private lazy var typeLabel: UILabel = {
        var label = UILabel()
        label.font = .Body1Regular
        return label
    }()

    private lazy var arrowButtonImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = CommonAsset.chevronRightOutline.image.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .Neutrals300
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
    }
    
    private func configureUI(){
        self.selectionStyle = .none
        self.separatorInset.right = 20
        self.separatorInset.left = 20
        
        self.addSubview(typeImageView)
        self.addSubview(typeLabel)
        self.addSubview(arrowButtonImageView)
        
        typeImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(self.typeImageView.snp.height)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalTo(typeImageView.snp.right).offset(10)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        arrowButtonImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
            make.right.equalToSuperview().offset(-20)
            make.width.equalTo(self.arrowButtonImageView.snp.height)
        }
    }
    
    func setSectionModel(model: MyPageItem){
        self.typeLabel.text = model.title
        self.typeImageView.image = model.image
    }
}
