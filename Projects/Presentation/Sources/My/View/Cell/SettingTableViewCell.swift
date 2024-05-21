//
//  SettingTableViewCell.swift
//  Presentation
//
//  Created by 유현진 on 5/19/24.
//

import UIKit
import SnapKit

class SettingTableViewCell: UITableViewCell {

    private lazy var typeImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(systemName: "xmark")
        return imageView
    }()
    
    private lazy var typeLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()

    private lazy var arrowButtonImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(systemName: "xmark")
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
    
    func setSectionModel(title: String){
        self.typeLabel.text = title
    }
}