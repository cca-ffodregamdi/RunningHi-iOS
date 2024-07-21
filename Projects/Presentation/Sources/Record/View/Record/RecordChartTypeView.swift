//
//  RecordChartTypeView.swift
//  Presentation
//
//  Created by najin on 7/21/24.
//

import UIKit
import SnapKit

enum RecordChartType {
    case weekly
    case monthly
    case yearly
}

class RecordChartTypeView: UIView {
    
    //MARK: - Properties
    
    private lazy var weeklyButton = RecordChartTypeButton(title: "주간")
    private lazy var monthlyButton = RecordChartTypeButton(title: "월간")
    private lazy var yearlyButton = RecordChartTypeButton(title: "연간")
    
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
