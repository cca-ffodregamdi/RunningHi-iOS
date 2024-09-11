//
//  RunningResultRecordView.swift
//  Presentation
//
//  Created by najin on 7/8/24.
//

import UIKit
import SnapKit
import MapKit

class RunningResultRecordView: UIView {
    
    //MARK: - Properties
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "구간 기록"
        label.font = .Subhead
        label.textColor = .black
        return label
    }()
    
    private var distanceLabel: UILabel = {
        let label = UILabel()
        label.text = "거리(km)"
        label.font = .CaptionRegular
        label.textColor = .Neutrals500
        label.textAlignment = .center
        return label
    }()
    
    private var averagePaceLabel: UILabel = {
        let label = UILabel()
        label.text = "평균 페이스"
        label.font = .CaptionRegular
        label.textColor = .Neutrals500
        label.textAlignment = .center
        return label
    }()
    
    private var calorieLabel: UILabel = {
        let label = UILabel()
        label.text = "소모 칼로리(kcal)"
        label.font = .CaptionRegular
        label.textColor = .Neutrals500
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
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(RunningResultRecordTableViewCell.self, forCellReuseIdentifier: RunningResultRecordTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 30
        return tableView
    }()
    
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
        headerStackView.addArrangedSubview(distanceLabel)
        headerStackView.addArrangedSubview(averagePaceLabel)
        headerStackView.addArrangedSubview(calorieLabel)
        
        addSubview(titleLabel)
        addSubview(headerStackView)
        addSubview(tableView)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(RunningResultView.horizontalPadding)
        }
        
        headerStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(RunningResultView.horizontalPadding)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerStackView.snp.bottom).offset(8)
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(RunningResultView.horizontalPadding)
            make.height.equalTo(10)
        }
    }
}
