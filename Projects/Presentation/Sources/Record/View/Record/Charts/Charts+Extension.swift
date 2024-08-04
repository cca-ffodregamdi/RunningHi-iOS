//
//  Charts+Extension.swift
//  Presentation
//
//  Created by najin on 8/3/24.
//

import Foundation
import Charts

extension BarChartView {

    private class BarChartFormatter: NSObject, AxisValueFormatter {
        
        var labels: [String] = []
        
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return labels[Int(value)]
        }
        
        init(labels: [String]) {
            super.init()
            self.labels = labels
        }
    }
    
    func setBarChartData(xValues: [String], yValues: [Double], label: String) {
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<yValues.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: yValues[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: label)
        chartDataSet.colors = Array(repeating: .Secondary100, count: xValues.count) // 바 색상 지정
        chartDataSet.drawValuesEnabled = false // 바 차트 상단에 값 노출 할건지
        
        let chartData = BarChartData(dataSet: chartDataSet)
        chartData.setValueTextColor(.red)
        
        let chartFormatter = BarChartFormatter(labels: xValues)
        let xAxis = XAxis()
        xAxis.valueFormatter = chartFormatter
        self.xAxis.valueFormatter = xAxis.valueFormatter
        
        self.data = chartData
    }
}
