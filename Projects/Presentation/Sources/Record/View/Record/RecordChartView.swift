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
        stackView.layoutMargins = .init(top: 10, left: 16, bottom: 10, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    var chartViewRenderer: RecordBarChartRenderer?
    
    lazy var chartView: BarChartView = {
        let chartView = BarChartView()
        
        chartView.doubleTapToZoomEnabled = false // 더블탭 확대 비활성
        chartView.scaleXEnabled = false // 좌우 확대 비활성
        chartView.scaleYEnabled = false // 상하 확대 비활성
        
        chartView.legend.enabled = false // 라벨링 hide
        
        chartView.xAxis.drawAxisLineEnabled = false // x축 값 그리드 선 없애기
        chartView.leftAxis.drawAxisLineEnabled = false // y축 값 그리드 선 없애기
        chartView.xAxis.drawGridLinesEnabled = false // 세로 그리드 선 없애기
        chartView.leftAxis.drawGridLinesEnabled = false // 가로 그리드 선 없애기
        
        chartView.rightAxis.enabled = false // 오른쪽 y축 값 제거
        chartView.xAxis.labelPosition = .bottom // x축 값 아래로 이동
        
        chartViewRenderer = RecordBarChartRenderer(dataProvider: chartView,
                                                   animator: chartView.chartAnimator,
                                                   viewPortHandler: chartView.viewPortHandler)
        
        // 차트 바 Custom
        chartView.renderer = chartViewRenderer
        
        return chartView
    }()
    
    lazy var chartRangeView = RecordChartRangeView()
    
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
            make.height.equalTo(60)
        }
        
        chartView.snp.makeConstraints { make in
            make.top.equalTo(recordDataStackView.snp.bottom).offset(-5)
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
        self.distanceLabel.text = "\(String(format: "%.2f", data.chartDatas.map{$0.distance}.reduce(0,+)))km"
        self.runningCountLabel.text = "/\(data.runCnt)번"
        
        self.setChartDataView(time: data.totalTime, pace: data.meanPace, kcal: data.totalKcal)
        self.setChartView(data: data)
        self.chartRangeView.setRange(range: DateUtil.dateToChartRangeFormatByType(type: data.chartType.calendarType, date: data.date))
    }
    
    func setChartDataView(time: Int, pace: Int, kcal: Int) {
        self.timeView.setData(data: TimeUtil.convertSecToTimeFormat(sec: time))
        self.paceView.setData(data: Int.convertMeanPaceToString(meanPace: pace))
        self.calorieView.setData(data: "\(Int.formatNumberWithComma(number: kcal))kcal")
    }
    
    func setChartView(data: RecordData) {
        let weekXList = ["월", "화", "수", "목", "금", "토", "일"]
        let dataXList = (0..<data.chartDatas.count).map { String($0+1) }
        
        if data.chartType != .monthly {
            chartView.xAxis.setLabelCount(data.chartType == .weekly ? weekXList.count : dataXList.count, force: false)
        } else {
            chartView.xAxis.setLabelCount(10, force: true)
        }
        
        chartView.leftAxis.axisMinimum = 0
        chartView.leftAxis.axisMaximum = data.chartDatas.map{$0.distance}.filter({$0 > 0}).max() ?? 10
        
        chartView.highlightValue(x: 0, dataSetIndex: -1)
        chartView.setBarChartData(xValues: data.chartType == .weekly ? weekXList : dataXList,
                                  yValues: data.chartDatas.map{$0.distance}, label: "")
    }
    
    func highlightRunningRecordView(_ isHighlited: Bool, _ highlight: Highlight?, _ index: Int) {
        self.recordDataStackView.backgroundColor = isHighlited ? .Primary : .white
        self.timeView.setHighlighted(isHighlited)
        self.paceView.setHighlighted(isHighlited)
        self.calorieView.setHighlighted(isHighlited)
        
        self.chartView.highlightValue(highlight)
        self.chartViewRenderer?.highlightedIndex = index
        
        self.chartView.notifyDataSetChanged()
    }
}
