//
//  MapView.swift
//  Presentation
//
//  Created by 오영석 on 5/11/24.
//

import UIKit
import MapKit
import SnapKit

class MapView: UIView {
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.layer.cornerRadius = 20
        mapView.layer.shadowRadius = 3
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
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
}
