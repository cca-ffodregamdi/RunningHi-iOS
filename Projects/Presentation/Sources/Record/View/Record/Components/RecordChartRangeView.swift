//
//  RecordChartRangeView.swift
//  Presentation
//
//  Created by najin on 7/21/24.
//

import UIKit
import SnapKit
import Common

class RecordChartRangeView: UIView {
    
    //MARK: - Properties
    
    private lazy var leftButton: UIButton = {
        let button = UIButton()
        let image = CommonAsset.chevronLeft.image.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .Secondary300
        return button
    }()
    
    private lazy var rangeLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.textAlignment = .center
        label.font = .Body2Regular
        return label
    }()
    
    private lazy var rightButton: UIButton = {
        let button = UIButton()
        let image = CommonAsset.chevronRight.image.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .Secondary300
        return button
    }()
    
    private lazy var rangeStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 17
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(leftButton)
        stackView.addArrangedSubview(rangeLabel)
        stackView.addArrangedSubview(rightButton)
        return stackView
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configureUI()
    }
    
    //MARK: - Configure
    
    private func configureUI() {
        addSubview(rangeStackView)
        
        rangeStackView.layer.borderColor = UIColor.Neutrals300.cgColor
        rangeStackView.layer.cornerRadius = 14
        rangeStackView.layer.borderWidth = 1
        
        rangeStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(28)
        }
    }
    
    //MARK: - Properties
    
    func setRange(range: String) {
        rangeLabel.text = range
    }
}

