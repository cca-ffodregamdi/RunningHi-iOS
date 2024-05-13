//
//  RunningCourseView.swift
//  Presentation
//
//  Created by 오영석 on 5/8/24.
//

import UIKit
import SnapKit

class RunningCourseView: UIView {
    
    lazy var mapView: MapView = {
        let mapView = MapView()
        return mapView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        addSubview(mapView)
    }
    
    private func setupConstraints() {
        let padding: CGFloat = 10
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(padding)
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(padding)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-padding)
            make.bottom.equalTo(self.snp.centerY)
        }
    }
}
