//
//  RecordChartTypeButton.swift
//  Presentation
//
//  Created by najin on 7/21/24.
//

import UIKit

class RecordChartTypeButton: UIButton {

    //MARK: - Properties
    
    private var typeLabel: UILabel = {
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
        
        typeLabel.text = title
        
        setupViews()
        setupConstraints()
    }
    
    //MARK: - Configure
    
    private func setupViews() {
        addSubview(typeLabel)
        
        layer.cornerRadius = 20
    }
    
    private func setupConstraints() {
        typeLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    //MARK: - Helpers
    
    func setActiveColor(isActive: Bool) {
        backgroundColor = .Secondary1000.withAlphaComponent(isActive ? 1 : 0)
        
        typeLabel.textColor = isActive ? .white : .Neutrals500
        typeLabel.font = isActive ? .Body1Bold : .Body1Regular
    }
}
