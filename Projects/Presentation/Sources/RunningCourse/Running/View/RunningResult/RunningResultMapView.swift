//
//  RunningResultMapView.swift
//  Presentation
//
//  Created by najin on 7/8/24.
//

import UIKit
import SnapKit
import MapKit
import Common

class RunningResultMapView: UIView {
    
    //MARK: - Properties
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "이동경로"
        label.font = .Subhead
        label.textColor = .black
        return label
    }()
    
    private lazy var locationMarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.locationMarkerOutline.image
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = .CaptionRegular
        label.textColor = .Neutrals500
        label.isHidden = true
        return label
    }()
    
    var mapView = RunningMapView()
    
    //MARK: - Lifecycle
    
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
    
    //MARK: - Configure
    
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(mapView)
        addSubview(locationMarkImageView)
        addSubview(locationLabel)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(RunningResultView.horizontalPadding)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.right.equalToSuperview().inset(RunningResultView.horizontalPadding)
        }
        
        locationMarkImageView.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.right.equalTo(locationLabel.snp.left)
            make.width.height.equalTo(20)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(RunningResultView.horizontalPadding)
            make.height.equalTo(136)
        }
    }
    
    func configureModelForFeedDetail(location: String){
        locationLabel.isHidden = false
        locationMarkImageView.isHidden = false
        locationLabel.text = location
    }
}
