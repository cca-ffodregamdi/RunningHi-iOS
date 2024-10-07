//
//  MyLevelView.swift
//  Presentation
//
//  Created by 유현진 on 8/17/24.
//

import UIKit
import Common
import SnapKit

class MyLevelView: UIView {

    private lazy var totalDistanceLabel: UILabel = {
        let label = UILabel()
        label.text = "누적"
        label.font = .Body1Bold
        label.textColor = .white
        return label
    }()
    
    lazy var questionMarkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "questionmark.circle.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private lazy var expBar: UIProgressView = {
        let progressView = UIProgressView()
        progressView.trackTintColor = .Primary1000
        progressView.progressTintColor = .Primary100
        progressView.progress = 0.5
        return progressView
    }()
    
    private lazy var currentLevelLabel: UILabel = {
        let label = UILabel()
        label.text = "Lv.1"
        label.font = .Body1Bold
        label.textColor = .white
        return label
    }()
      
    private lazy var remainDistanceLabel: UILabel = {
        let label = UILabel()
        label.text = "1km만 더 뛰면 "
        label.font = .CaptionRegular
        label.textColor = .white
        return label
    }()
    
    private lazy var nextLevelLabel: UILabel = {
        let label = UILabel()
        label.text = "Lv.2"
        label.font = .Body1Bold
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.backgroundColor = .Primary
        self.clipsToBounds = true
        
        [totalDistanceLabel, questionMarkButton, expBar, currentLevelLabel, remainDistanceLabel, nextLevelLabel].forEach{
            self.addSubview($0)
        }
        
        totalDistanceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(30)
        }
        
        questionMarkButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-30)
            make.width.height.equalTo(20)
        }
        
        expBar.snp.makeConstraints { make in
            make.top.equalTo(questionMarkButton.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(8)
        }
        
        currentLevelLabel.snp.makeConstraints { make in
            make.top.equalTo(expBar.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(30)
            make.bottom.equalToSuperview().offset(-15)
        }
        
        remainDistanceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nextLevelLabel)
            make.right.equalTo(nextLevelLabel.snp.left).offset(-5)
        }
        
        nextLevelLabel.snp.makeConstraints { make in
            make.top.equalTo(expBar.snp.bottom).offset(5)
            make.right.equalToSuperview().offset(-30)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    
    func configureModel(totalDistance: Double, currentLevel: Int, remainDistance: Double){
        let nextLevel = currentLevel + 1
        totalDistanceLabel.text = "누적 " + String(format: "%.2f", totalDistance) + "km"
        currentLevelLabel.text = "Lv.\(currentLevel)"
        nextLevelLabel.text = "Lv.\(nextLevel)"
        remainDistanceLabel.text = String(format: "%.2f", remainDistance) + "km만 더 뛰면"
        
        expBar.progress =  Float(totalDistance) / Float((nextLevel * (nextLevel - 1) * 2) / 2)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height * 0.25
    }
}
