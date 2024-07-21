//
//  RecordRunningListTableViewCell.swift
//  Presentation
//
//  Created by najin on 7/21/24.
//

import UIKit
import SnapKit
import Common

class RecordRunningListTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier = "RecordRunningListTableViewCell"
    
    private var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        return view
    }()
    
    private var mapView: UIView = {
        let view = UIView()
        view.backgroundColor = .Neutrals500
        return view
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .Subhead
        label.textColor = .black
        label.text = "00월 00일 러닝"
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .CaptionRegular
        label.textColor = .black
        label.text = "00.00km 00:00:00"
        return label
    }()
    
    private var locationLabel: UILabel = {
        let label = UILabel()
        label.font = .CaptionRegular
        label.textColor = .Secondary700
        label.text = "중구, 서울"
        return label
    }()
    
    private var arrowButton: UIButton = {
        let button = UIButton()
        button.setImage(CommonAsset.chevronRightOutline.image, for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private var badgeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.badge.image
        return imageView
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure
    
    private func configureUI() {
        contentView.backgroundColor = .Secondary100
        
        addSubview(containerView)
        addSubview(mapView)
        addSubview(badgeImageView)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(locationLabel)
        containerView.addSubview(arrowButton)
        
        mapView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.left.equalToSuperview()
            make.width.equalTo(89)
            make.height.equalTo(98)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        badgeImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview().offset(-24)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.left.right.equalToSuperview()
            make.height.equalTo(98)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        arrowButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
            make.width.equalTo(25)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalTo(mapView.snp.right).offset(16)
            make.right.equalTo(arrowButton.snp.left)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(7)
            make.left.equalTo(mapView.snp.right).offset(16)
            make.right.equalTo(arrowButton.snp.left)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(5)
            make.left.equalTo(mapView.snp.right).offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.right.equalTo(arrowButton.snp.left)
        }
    }
}
