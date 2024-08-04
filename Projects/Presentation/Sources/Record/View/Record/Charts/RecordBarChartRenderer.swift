//
//  RecordBarChartRenderer.swift
//  Presentation
//
//  Created by najin on 8/3/24.
//

import UIKit
import Charts

class RecordBarChartRenderer: BarChartRenderer {
    
    var highlightedIndex: Int? // 클릭된 막대의 인덱스를 저장
    
    override func drawDataSet(context: CGContext, dataSet: BarChartDataSetProtocol, index: Int) {
        guard let barDataProvider = dataProvider else { return }
        let trans = barDataProvider.getTransformer(forAxis: dataSet.axisDependency)
        var barRectBuffer = CGRect()
        
        context.saveGState()
        
        context.beginTransparencyLayer(auxiliaryInfo: .none)
        
        for i in stride(from: dataSet.entryCount - 1, through: 0, by: -1) {
            guard let e = dataSet.entryForIndex(i) as? BarChartDataEntry else { continue }
            
            let x = e.x
            let y = e.y
            let left = x - 0.5
            let right = x + 0.5
            let top = y >= 0.0 ? y : 0.0
            let bottom = y <= 0.0 ? y : 0.0
            
            barRectBuffer.origin.x = CGFloat(left)
            barRectBuffer.size.width = CGFloat(right - left)
            barRectBuffer.origin.y = CGFloat(top)
            barRectBuffer.size.height = CGFloat(bottom - top)
            
            trans.rectValueToPixel(&barRectBuffer)
            
            
            let originalWidth = barRectBuffer.size.width
            let modifiedWidth = originalWidth * 0.9
            let cornerRadius: CGFloat = modifiedWidth / 2
//            let cornerRadius: CGFloat = 10
            
            let xOffset = (originalWidth - modifiedWidth) / 2.0
            
            let path = UIBezierPath(roundedRect: CGRect(x: barRectBuffer.origin.x + xOffset,
                                                        y: barRectBuffer.origin.y,
                                                        width: modifiedWidth,
                                                        height: barRectBuffer.size.height),
                                    byRoundingCorners: [.topLeft , .topRight],
                                    cornerRadii: CGSize(width: barRectBuffer.width * cornerRadius, height: barRectBuffer.height * cornerRadius)
            ).cgPath
            
            context.addPath(path)
            context.closePath()
            
            context.setFillColor(dataSet.color(atIndex: i).cgColor)
            context.drawPath(using: .fill)
        }
        
        context.endTransparencyLayer()
        context.restoreGState()
    }
    
    override func drawExtras(context: CGContext) {
        super.drawExtras(context: context)
        
        guard let dataProvider = dataProvider else { return }
        guard let barData = dataProvider.barData else { return }
        
        for dataSetIndex in 0..<barData.dataSetCount {
            guard let highlightedIndex = highlightedIndex else { return }
            guard let dataSet = barData.dataSets[dataSetIndex] as? BarChartDataSet else { continue }
            
            for j in 0..<dataSet.count {
                if j == highlightedIndex {
                    guard let entry = dataSet[j] as? BarChartDataEntry, entry.y > 0 else { continue }
                    let transformer = dataProvider.getTransformer(forAxis: dataSet.axisDependency)
                    let point = transformer.pixelForValues(x: entry.x, y: 1)
                    
                    context.setStrokeColor(UIColor.Primary.cgColor) // 선 색상 설정
                    context.setLineWidth(1.0) // 선 두께 설정
                    context.move(to: CGPoint(x: point.x, y: 5))
                    context.addLine(to: point)
                    context.strokePath()
                }
            }
        }
    }
}
