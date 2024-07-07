//
//  RunningReadyView.swift
//  Presentation
//
//  Created by najin on 7/7/24.
//

import UIKit
import SnapKit

class RunningReadyView: UIView {
    
    //MARK: - Properties
    
    private var readyTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .systemFont(ofSize: 100, weight: .bold)
        label.textColor = .Primary
        return label
    }()
    
    private var readyInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "잠시 후 러닝을 시작합니다"
        label.font = .Subhead
        label.textColor = .Neutrals600
        return label
    }()
    
    private var timerStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 25
        return stackView
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
        addSubview(timerStackView)
        timerStackView.addArrangedSubview(readyTimeLabel)
        timerStackView.addArrangedSubview(readyInfoLabel)
    }
    
    private func setupConstraints() {
        timerStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

