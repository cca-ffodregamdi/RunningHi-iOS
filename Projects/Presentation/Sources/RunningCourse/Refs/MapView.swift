//
//  MapView.swift
//  Presentation
//
//  Created by 오영석 on 5/11/24.
//

import UIKit
import MapKit
import SnapKit

//class MapView: UIView {
//    
//    lazy var mapView: MKMapView = {
//        let mapView = MKMapView()
//        mapView.layer.cornerRadius = 20
//        mapView.layer.shadowRadius = 3
//        return mapView
//    }()
//    
//    lazy var compassButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setImage(UIImage(systemName: "scope"), for: .normal)
//        button.tintColor = .black
//        button.backgroundColor = .white
//        button.layer.borderWidth = 1.0
//        button.layer.cornerRadius = 10
//        
//        return button
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupViews()
//        setupConstraints()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setupViews()
//        setupConstraints()
//    }
//    
//    private func setupViews() {
//        addSubview(mapView)
//        
//        [compassButton]
//            .forEach { item in
//                self.addSubview(item)
//            }
//    }
//    
//    private func setupConstraints() {
//        let padding: CGFloat = 10
//        
//        mapView.snp.makeConstraints { make in
//            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(padding)
//            make.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(padding)
//            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-padding)
//            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
//        }
//        compassButton.snp.makeConstraints { make in
//            make.trailing.equalTo(mapView.snp.trailing).offset(-padding)
//            make.bottom.equalTo(mapView.snp.bottom).offset(-padding)
//        }
//    }
//}
