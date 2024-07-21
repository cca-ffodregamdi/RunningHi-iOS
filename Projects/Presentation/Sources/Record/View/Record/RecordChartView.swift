//
//  RecordChartView.swift
//  Presentation
//
//  Created by najin on 7/21/24.
//

import UIKit
import SnapKit

class RecordChartView: UIView {
    
    //MARK: - Properties
    
    private lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.text = "0.0km"
        label.font = .Display1
        label.textColor = .black
        return label
    }()
    
    private lazy var runningCountLabel: UILabel = {
        let label = UILabel()
        label.text = "/0번"
        label.font = .Subhead
        label.textColor = .Neutrals500
        return label
    }()
    
    private lazy var recordDistanceStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(distanceLabel)
        stackView.addArrangedSubview(runningCountLabel)
        return stackView
    }()
    
    private lazy var timeView = RecordDataView(title: "시간")
    private lazy var paceView = RecordDataView(title: "평균 페이스")
    private lazy var calorieView = RecordDataView(title: "소비 칼로리")
    
    private lazy var recordDataStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(timeView)
        stackView.addArrangedSubview(paceView)
        stackView.addArrangedSubview(calorieView)
        return stackView
    }()
    
    private lazy var chartView: UIView = {
        let view = UIView()
        view.backgroundColor = .Secondary100
        return view
    }()
    
    private lazy var chartRangeView = RecordChartRangeView()
    
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
        addSubview(distanceLabel)
        addSubview(runningCountLabel)
        addSubview(chartView)
        addSubview(chartRangeView)
        addSubview(recordDataStackView)
        
        distanceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(RecordView.horizontalPadding)
        }
        
        runningCountLabel.snp.makeConstraints { make in
            make.bottom.equalTo(distanceLabel.snp.bottom).offset(-5)
            make.left.equalTo(distanceLabel.snp.right).offset(8)
        }
        
        recordDataStackView.snp.makeConstraints { make in
            make.top.equalTo(distanceLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(RecordView.horizontalPadding)
            make.height.equalTo(40)
        }
        
        chartView.snp.makeConstraints { make in
            make.top.equalTo(recordDataStackView.snp.bottom).offset(8)
            make.height.equalTo(170)
            make.left.right.equalToSuperview().inset(RecordView.horizontalPadding)
        }
        
        chartRangeView.snp.makeConstraints { make in
            make.top.equalTo(chartView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
