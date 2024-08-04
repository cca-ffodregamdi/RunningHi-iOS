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
    
    lazy var leftButton: UIButton = {
        let button = UIButton()
        let image = CommonAsset.chevronLeft.image.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .Secondary300
        return button
    }()
    
    lazy var rangeButton: UIButton = {
        let button = UIButton()
        button.setTitle("-", for: .normal)
        button.titleLabel?.font = .Body2Regular
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton()
        let image = CommonAsset.chevronRight.image.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .Secondary300
        return button
    }()
    
    private lazy var rangeStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.addArrangedSubview(leftButton)
        stackView.addArrangedSubview(rangeButton)
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
        rangeButton.setTitle(range, for: .normal)
    }
}
