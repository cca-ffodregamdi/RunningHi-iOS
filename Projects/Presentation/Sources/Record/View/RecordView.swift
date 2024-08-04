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
    lazy var chartArea = RecordChartView()
    var runningListView = RecordRunningListView()
    
    private lazy var recordStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .fill
        stackView.backgroundColor = .white
        stackView.addArrangedSubview(chartTypeView)
        stackView.addArrangedSubview(chartArea)
        stackView.addArrangedSubview(runningListView)
        return stackView
    }()
    
    private lazy var bottomBackgroundView = {
        let view = UIView()
        view.backgroundColor = .Secondary100
        return view
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
        addSubview(bottomBackgroundView)
        bottomBackgroundView.snp.makeConstraints { make in
            make.height.equalTo(00)
            make.left.right.bottom.equalToSuperview()
        }
        
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        recordStackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        
        bringSubviewToFront(scrollView)
    }
    
    //MARK: - Helpers
    
    func setData(data: RecordData) {
        self.chartArea.setData(data: data)
        
        self.runningListView.setNoneView(data.runningRecords.isEmpty)
        
        bottomBackgroundView.snp.updateConstraints { make in
            make.height.equalTo(self.frame.size.height / 2)
        }
    }
}

