//
//  RecordChartTypeView.swift
//  Presentation
//
//  Created by najin on 7/21/24.
//

import UIKit
import SnapKit
import Domain

class RecordChartTypeView: UIView {
    
    //MARK: - Properties
    
    lazy var weeklyButton = RecordChartTypeButton(title: "주간")
    lazy var monthlyButton = RecordChartTypeButton(title: "월간")
    lazy var yearlyButton = RecordChartTypeButton(title: "연간")
    
    private lazy var buttonStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(weeklyButton)
        stackView.addArrangedSubview(monthlyButton)
        stackView.addArrangedSubview(yearlyButton)
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
        addSubview(buttonStackView)
        
        buttonStackView.backgroundColor = .BaseWhite
        buttonStackView.layer.cornerRadius = 20
        
        buttonStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(RecordView.horizontalPadding)
            make.height.equalTo(40)
        }
    }
    
    //MARK: - Properties
    
    func setChartType(type: RecordChartType) {
        weeklyButton.setActiveColor(isActive: type == .weekly)
        monthlyButton.setActiveColor(isActive: type == .monthly)
        yearlyButton.setActiveColor(isActive: type == .yearly)
    }
}
