//
//  RecordView.swift
//  Presentation
//
//  Created by najin on 7/21/24.
//

import UIKit
import SnapKit
import Domain

class RecordView: UIView {
    
    //MARK: - Configure
    
    static var horizontalPadding = 20
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.addSubview(recordStackView)
        return scrollView
    }()
    
    lazy var chartTypeView = RecordChartTypeView()
    lazy var chartView = RecordChartView()
    var runningListView = RecordRunningListView()
    
    private lazy var recordStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .fill
        stackView.addArrangedSubview(chartTypeView)
        stackView.addArrangedSubview(chartView)
        stackView.addArrangedSubview(runningListView)
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
        addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        recordStackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Helpers
    
    func setData(data: RecordData) {
        self.chartView.setData(data: data)
    }
}

