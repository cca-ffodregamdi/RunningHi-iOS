//
//  FeedDetailRecordView.swift
//  Presentation
//
//  Created by 유현진 on 6/10/24.
//

import UIKit
import SnapKit
import Common
import Domain

final class FeedDetailRecordView: UIView {
    
    private lazy var recordTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "기록"
        label.textColor = UIColor.colorWithRGB(r: 13, g: 13, b: 13)
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private lazy var difficultyLabel: DifficultyLabel = {
        let label = DifficultyLabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private lazy var recordStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        return stackView
    }()
    
    private lazy var timeElementView: FeedDetailRecordElementView = {
        return FeedDetailRecordElementView()
    }()
    
    private lazy var timeDistanceBreakLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.colorWithRGB(r: 232, g: 235, b: 237)
        return view
    }()
    
    private lazy var distanceElementView: FeedDetailRecordElementView = {
        return FeedDetailRecordElementView()
    }()
    
    private lazy var distanceMeanPaceBreakLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.colorWithRGB(r: 232, g: 235, b: 237)
        return view
    }()
    
    private lazy var meanPaceElementView: FeedDetailRecordElementView = {
        return FeedDetailRecordElementView()
    }()
    
    private lazy var meanPaceKcalBreakLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.colorWithRGB(r: 232, g: 235, b: 237)
        return view
    }()
    
    private lazy var kcalElementView: FeedDetailRecordElementView = {
        return FeedDetailRecordElementView()
    }()
    
    private lazy var routeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "이동 경로"
        label.textColor = UIColor.colorWithRGB(r: 13, g: 13, b: 13)
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private lazy var loactionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.locationMarkerOutline.image
        return imageView
    }()
    
    private lazy var loactionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.colorWithRGB(r: 130, g: 143, b: 155)
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
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
        self.backgroundColor = .systemBackground
        
        self.addSubview(recordTitleLabel)
        self.addSubview(difficultyLabel)
        [timeElementView, timeDistanceBreakLine, distanceElementView, distanceMeanPaceBreakLine, meanPaceElementView, meanPaceKcalBreakLine, kcalElementView].forEach{
            self.recordStackView.addArrangedSubview($0)
        }
        self.addSubview(recordStackView)
        
        recordTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        difficultyLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        recordStackView.snp.makeConstraints { make in
            make.top.equalTo(recordTitleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
        }
        
        [timeDistanceBreakLine, distanceMeanPaceBreakLine, meanPaceKcalBreakLine].forEach{
            $0.snp.makeConstraints { make in
                make.height.equalTo(1)
            }
        }
    }
    
    func configureModel(difficulty: FeedDetailDifficultyType, time: Int, distance: Float, meanPace: Int, kcal: Int){
        timeElementView.configureModel(title: "시간", value: Date.formatSecondsToHHMMSS(seconds: time))
        distanceElementView.configureModel(title: "거리", value: "\(distance) km")
        meanPaceElementView.configureModel(title: "평균 페이스", value: Int.convertMeanPaceToString(meanPace: meanPace))
        kcalElementView.configureModel(title: "소모 칼로리", value: "\(kcal) kcal")
        difficultyLabel.setTitle(difficulty: difficulty)
    }
}
