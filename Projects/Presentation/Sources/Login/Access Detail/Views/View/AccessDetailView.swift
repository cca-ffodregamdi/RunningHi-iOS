//
//  AccessDetailView.swift
//  Presentation
//
//  Created by 유현진 on 8/9/24.
//

import UIKit
import SnapKit
import Common

class AccessDetailView: UIView {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .Subhead
        label.textColor = .black
        return label
    }()
    
    private lazy var breakLine: UIView = {
        let view = UIView()
        view.backgroundColor = .BaseWhite
        return view
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .Body2Bold
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    init(){
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.addSubview(scrollView)
        [titleLabel,
        breakLine,
         contentLabel].forEach{
            self.scrollView.addSubview($0)
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.width.equalToSuperview().offset(-40)
        }
        
        breakLine.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(2)
            make.width.equalToSuperview().offset(-40)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(breakLine.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview().inset(20)
            make.width.equalToSuperview().offset(-40)
        }
    }
    
    func configureModel(model: AccessModel){
        titleLabel.text = model.title
        contentLabel.text = model.content
    }
}
