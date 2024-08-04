//
//  RecordDataView.swift
//  Presentation
//
//  Created by najin on 7/21/24.
//

import UIKit
import SnapKit

class RecordDataView: UIView {
    
    //MARK: - Properties
    
    private var dataLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.textAlignment = .center
        label.font = .Headline
        label.textColor = .black
        return label
    }()
    
    private var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.textAlignment = .center
        label.font = .CaptionRegular
        label.textColor = .Neutrals400
        return label
    }()
    
    private var dataStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .fill
        return stackView
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init(title: String) {
        super.init(frame: .zero)
        
        subTitleLabel.text = title
        
        setupViews()
        setupConstraints()
    }
    
    //MARK: - Configure
    
    private func setupViews() {
        addSubview(dataStackView)
        dataStackView.addArrangedSubview(dataLabel)
        dataStackView.addArrangedSubview(subTitleLabel)
    }
    
    private func setupConstraints() {
        dataStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - Properties
    
    func setData(data: String) {
        dataLabel.text = data
    }
    
    func setHighlighted(_ isHighlited: Bool) {
        dataLabel.textColor = isHighlited ? .white : .black
        subTitleLabel.textColor = isHighlited ? .white : .Neutrals400
    }
}
