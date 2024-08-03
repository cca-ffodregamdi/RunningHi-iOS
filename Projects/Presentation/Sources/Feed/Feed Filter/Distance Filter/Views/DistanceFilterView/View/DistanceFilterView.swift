//
//  DistanceFilterView.swift
//  Presentation
//
//  Created by 유현진 on 8/1/24.
//

import UIKit
import Common
import SnapKit

class DistanceSlider: UISlider{
    override public func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        let thumbRect = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        let xOffset: CGFloat = value > super.minimumValue ? 10 : -10 // Size of the custom thumb image
        var origin = thumbRect.origin
        origin.x += xOffset
        return CGRect(origin: origin, size: thumbRect.size)
    }
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return .init(origin: bounds.origin, size: CGSize(width: bounds.width, height: 8))
    }
}

class DistanceFilterView: UIView {
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "내 반경 설정"
        label.textColor = .black
        label.font = .Subhead
        return label
    }()
    
    lazy var cancelButton: UIButton = {
        var button = UIButton()
        button.setImage(CommonAsset.xOutline.image, for: .normal)
        return button
    }()
    
    private lazy var locationLabel: UILabel = {
        var label = UILabel()
        label.text = "현재 위치"
        label.textColor = .black
        label.font = .Body2Regular
        return label
    }()
    
    lazy var distanceSlider: DistanceSlider = {
        var slider = DistanceSlider()
        slider.minimumValue = 0
        slider.maximumValue = 3
        slider.value = 0
        slider.tintColor = .Primary
        slider.maximumTrackTintColor = .Primary100
        slider.setThumbImage(CommonAsset.thumb.image, for: .normal)
        return slider
    }()
    
    private lazy var stackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private lazy var aroundLabel: UILabel = {
        var label = UILabel()
        label.text = DistanceFilter.around.title
        label.font = .CaptionRegular
        label.textColor = .black
        return label
    }()
    
    private lazy var around5Label: UILabel = {
        var label = UILabel()
        label.text = DistanceFilter.around5.title
        label.font = .CaptionRegular
        label.textColor = .black
        return label
    }()
    
    private lazy var around10Label: UILabel = {
        var label = UILabel()
        label.text = DistanceFilter.around10.title
        label.font = .CaptionRegular
        label.textColor = .black
        return label
    }()
    
    private lazy var allLabel: UILabel = {
        var label = UILabel()
        label.text = DistanceFilter.all.title
        label.font = .CaptionRegular
        label.textColor = .black
        return label
    }()
    
    lazy var resetButton: UIButton = {
        var button = UIButton()
        button.setTitle("초기화", for: .normal)
        button.setTitleColor(.Primary, for: .normal)
        button.setTitleColor(.Neutrals300, for: .disabled)
        button.backgroundColor = .clear
        button.titleLabel?.font = .Body1Regular
        button.clipsToBounds = true
        return button
    }()
    
    lazy var applyButton: UIButton = {
        var button = UIButton()
        button.setTitle("적용", for: .normal)
        button.setTitleColor(.BaseWhite, for: .normal)
        button.backgroundColor = .Primary
        button.titleLabel?.font = .Body1Regular
        button.clipsToBounds = true
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = 24
        self.clipsToBounds = true
        self.addSubview(titleLabel)
        self.addSubview(cancelButton)
        self.addSubview(locationLabel)
        self.addSubview(distanceSlider)
        self.addSubview(stackView)
        self.addSubview(resetButton)
        self.addSubview(applyButton)
        
        [aroundLabel, around5Label, around10Label, allLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.left.equalToSuperview().offset(20)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.width.height.equalTo(24)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        distanceSlider.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(distanceSlider.snp.bottom).offset(-20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        resetButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(40)
            make.width.equalToSuperview().offset(-40).dividedBy(2.5)
        }
        
        applyButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(20)
            make.left.equalTo(resetButton.snp.right).offset(10)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyButton.layer.cornerRadius = applyButton.frame.height/2
        resetButton.layer.cornerRadius = resetButton.frame.height/2
    }
}
