//
//  RecordChartView.swift
//  Presentation
//
//  Created by najin on 7/21/24.
//

import UIKit
import SnapKit
import Domain
import Common
import Charts

class RecordChartView: UIView {
    
    //MARK: - Properties
    
    lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.text = "0.0km"
        label.font = .Display1
        label.textColor = .black
        return label
    }()
    
    lazy var runningCountLabel: UILabel = {
        let label = UILabel()
        label.text = "/0번"
        label.font = .Subhead
        label.textColor = .Neutrals500
        return label
    }()
    
    lazy var recordDistanceStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(distanceLabel)
        stackView.addArrangedSubview(runningCountLabel)
        return stackView
    }()
    
    lazy var timeView = RecordDataView(title: "시간")
    lazy var paceView = RecordDataView(title: "평균 페이스")
    lazy var calorieView = RecordDataView(title: "소비 칼로리")
    
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
    
    private lazy var chartView: BarChartView = {
        let chartView = BarChartView()
        chartView.doubleTapToZoomEnabled = false
        chartView.legend.enabled = false
        
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.rightAxis.enabled = false
        chartView.leftAxis.drawAxisLineEnabled = false
        chartView.xAxis.labelPosition = .bottom
        
        chartView.rightAxis.axisLineColor = .white
        chartView.rightAxis.axisLineColor = .white
        
        return chartView
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
    
    //MARK: - Helpers
    
    func setData(data: RecordData) {
        self.distanceLabel.text = "\(data.chartDatas.reduce(0,+))km"
        self.runningCountLabel.text = "/\(data.chartDatas.filter {$0 > 0.0}.count)번"
        
        self.timeView.setData(data: TimeUtil.convertSecToTimeFormat(sec: data.totalTime))
        self.paceView.setData(data: Int.convertMeanPaceToString(meanPace: data.meanPace))
        self.calorieView.setData(data: "\(Int.formatNumberWithComma(number: data.totalKcal))kcal")
        
        //TODO: Chart 구현하기
        
        var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        var unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<months.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(unitsSold[i]))
            dataEntries.append(dataEntry)
        }

        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "판매량")

        // 차트 컬러
        chartDataSet.colors = [.red]

        // 데이터 삽입
        let chartData = BarChartData(dataSet: chartDataSet)
        chartView.data = chartData
    }
}
