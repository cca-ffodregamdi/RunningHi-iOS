//
//  RunningMarkerView.swift
//  Presentation
//
//  Created by najin on 8/25/24.
//

import UIKit
import MapKit

class RunningAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var isStart: Bool = true
    
    init(coordinate: CLLocationCoordinate2D, isStart: Bool) {
        self.coordinate = coordinate
        self.isStart = isStart
        self.title = ""
        self.subtitle = ""
    }
}

class RunningMarkerView: UIView {
    
    let borderWidth: CGFloat = 3.0
    
    lazy var fillColor: UIColor = .white
    lazy var borderColor: UIColor = .white
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    required init?(isStart: Bool) {
        super.init(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
        
        configureUI()
        
        fillColor = isStart ? .Primary700 : .white
        borderColor = isStart ? .white : .Primary700 //.Primary500
    }
    
    private func configureUI() {
        self.backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let circlePath = UIBezierPath(ovalIn: rect.insetBy(dx: borderWidth / 2, dy: borderWidth / 2))
        
        fillColor.setFill()
        context.addPath(circlePath.cgPath)
        context.fillPath()
        
        borderColor.setStroke()
        circlePath.lineWidth = borderWidth
        circlePath.stroke()
    }
}
