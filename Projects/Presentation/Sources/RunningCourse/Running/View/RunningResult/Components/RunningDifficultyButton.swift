//
//  RunningDifficultyButton.swift
//  Presentation
//
//  Created by najin on 7/9/24.
//

import UIKit

class RunningDifficultyButton: UIButton {

    //MARK: - Properties
    
    static var width = 66
    
    private var circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .Neutrals300
        view.layer.cornerRadius = 6
        return view
    }()
    
    private var difficultuLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = .Body2Regular
        label.textColor = .Neutrals300
        return label
    }()
    
    //MARK: - Lifecycle
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    required init(title: String) {
        super.init(frame: .zero)
        
        difficultuLabel.text = title
        
        setupViews()
        setupConstraints()
    }
    
    //MARK: - Configure
    
    private func setupViews() {
        backgroundColor = .white.withAlphaComponent(0)
        
        addSubview(circleView)
        addSubview(difficultuLabel)
    }
    
    private func setupConstraints() {
        circleView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(12)
        }
        
        difficultuLabel.snp.makeConstraints { make in
            make.top.equalTo(circleView.snp.bottom).offset(8)
            make.bottom.equalToSuperview()
            make.width.equalTo(RunningDifficultyButton.width)
        }
    }
    
    //MARK: - Helpers
    
    func setActiveColor(isActive: Bool) {
        circleView.backgroundColor = isActive ? .black : .Neutrals300
    }
}
