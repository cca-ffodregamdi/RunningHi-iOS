//
//  RunningResultRecordTableViewCell.swift
//  Presentation
//
//  Created by najin on 7/9/24.
//

import UIKit
import SnapKit

class RunningResultRecordTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier = "RunningResultRecordTableViewCell"
    
    private var distanceLabel: UILabel = {
        let label = UILabel()
        label.font = .Body2Regular
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private var averagePaceLabel: UILabel = {
        let label = UILabel()
        label.font = .Body2Regular
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private var calorieLabel: UILabel = {
        let label = UILabel()
        label.font = .Body2Regular
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private var headerStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private var lineView = CustomLineView()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure
    
    private func setupViews() {
        addSubview(headerStackView)
        headerStackView.addArrangedSubview(distanceLabel)
        headerStackView.addArrangedSubview(averagePaceLabel)
        headerStackView.addArrangedSubview(calorieLabel)
        
        addSubview(lineView)
    }
    
    private func setupConstraints() {
        headerStackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(headerStackView.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        }
    }
    
    //MARK: - Helpers
    
    func setData(distance: Double, time: Int) {
        distanceLabel.text = "\(Int(distance))"
        averagePaceLabel.text = "\(Int.convertTimeAndDistanceToPace(time: time, distance: distance))"
        calorieLabel.text = "\(Int.convertTimeToCalorie(time: time))"
    }
    
    func setData(distance: Int, kcal: Int, pace: Int) {
        distanceLabel.text = "\(distance)"
        averagePaceLabel.text = "\(pace)"
        calorieLabel.text = "\(kcal)"
    }
    
    func removeLine() {
        lineView.isHidden = true
    }
}
