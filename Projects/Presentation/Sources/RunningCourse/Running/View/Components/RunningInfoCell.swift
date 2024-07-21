//
//  RunningInfoCell.swift
//  Presentation
//
//  Created by najin on 7/7/24.
//

import UIKit
import SnapKit

class RunningInfoCell: UIView {
    
    //MARK: - Properties
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "title"
        label.textAlignment = .left
        label.font = .Body2Regular
        label.textColor = .Neutrals500
        return label
    }()
    
    private var dataLabel: UILabel = {
        let label = UILabel()
        label.text = "subtitle"
        label.textAlignment = .right
        label.font = .Display2
        label.textColor = .black
        return label
    }()
    
    private var infoStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        setupConstraints()
    }
    
    required init(title: String, initData: String = " ") {
        super.init(frame: .zero)
        
        titleLabel.text = title
        dataLabel.text = initData
        
        setupViews()
        setupConstraints()
    }
    
    //MARK: - Configure
    
    private func setupViews() {
        addSubview(infoStackView)
        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(dataLabel)
    }
    
    private func setupConstraints() {
        infoStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - Helpers
    
    func setData(data: String) {
        dataLabel.text = data
    }
}
