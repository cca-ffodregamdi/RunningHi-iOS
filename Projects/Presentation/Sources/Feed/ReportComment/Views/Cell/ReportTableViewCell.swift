//
//  ReportTableViewCell.swift
//  Presentation
//
//  Created by 유현진 on 6/20/24.
//

import UIKit
import Common
import SnapKit

class ReportTableViewCell: UITableViewCell {

    private lazy var checkBoxButton: UIButton = {
        let button = UIButton()
        button.setImage(CommonAsset.checkBoxFalse.image, for: .normal)
        button.setImage(CommonAsset.checkBoxTrue.image, for: .selected)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private lazy var isCheck: Bool = false{
        didSet{
            checkBoxButton.isSelected = isSelected
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        isCheck.toggle()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.selectionStyle = .none
        
        self.addSubview(checkBoxButton)
        self.addSubview(titleLabel)
        
        checkBoxButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-15)
            make.width.equalTo(checkBoxButton.snp.height)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(checkBoxButton.snp.centerY)
            make.left.equalTo(checkBoxButton.snp.right).offset(10)
        }
    }
    
    func configureModel(title: String){
        titleLabel.text = title
    }
}
