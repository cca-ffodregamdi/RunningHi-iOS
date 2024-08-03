//
//  SortFilterTableViewCell.swift
//  Presentation
//
//  Created by 유현진 on 8/1/24.
//

import UIKit
import SnapKit
import Common
class SortFilterTableViewCell: UITableViewCell {

    static let identitier: String = "sortFilterCell"
    
    private lazy var checkBoxButton: UIButton = {
        let button = UIButton()
        button.setImage(CommonAsset.checkBoxFalse.image, for: .normal)
        button.setImage(CommonAsset.checkBoxTrue.image, for: .selected)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .Body2Regular
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
        
        self.addSubview(titleLabel)
        self.addSubview(checkBoxButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
        
        checkBoxButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.right.equalToSuperview().offset(-20)
            make.left.greaterThanOrEqualTo(titleLabel.snp.right).offset(20)
            make.width.equalTo(checkBoxButton.snp.height)
        }
    }
    
    func configureModel(title: String){
        titleLabel.text = title
    }
}
