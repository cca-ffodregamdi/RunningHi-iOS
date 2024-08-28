//
//  FeedbackTypeTableViewCell.swift
//  Presentation
//
//  Created by 유현진 on 8/28/24.
//

import UIKit
import Common
import SnapKit
import RxSwift

class FeedbackTypeTableViewCell: UITableViewCell {
    
    static let identifier: String = "feedbackTypeCell"
    
    var disposeBag: DisposeBag = DisposeBag()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .Body1Regular
        label.textColor = .BaseBlack
        label.text = "카테고리 선택"
        return label
    }()
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        return UITapGestureRecognizer()
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        addTapGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
    
    private func configureUI(){
        self.selectionStyle = .none
    
        self.contentView.addSubview(titleLabel)
    
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.left.right.equalToSuperview().inset(16)
        }
    }
    
    func configureModel(type: String){
        self.titleLabel.text = type
    }
    
    private func addTapGestureRecognizer(){
        self.addGestureRecognizer(tapGestureRecognizer)
    }
}
