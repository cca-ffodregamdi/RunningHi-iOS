//
//  RunningView.swift
//  Presentation
//
//  Created by najin on 7/7/24.
//

import UIKit
import SnapKit

class RunningView: UIView {
    
    //MARK: - Configure
    
    var runningReadyView = RunningReadyView()
    var runningRecordView = RunningRecordView()
    
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
        addSubview(runningReadyView)
        addSubview(runningRecordView)
        
        bringSubviewToFront(runningReadyView)
    }
    
    private func setupConstraints() {
        runningReadyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        runningRecordView.snp.makeConstraints { make in
            make.top.bottom.equalTo(self.safeAreaLayoutGuide)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    //MARK: - Helpers
    
    func setReadyView(time: Int) {
        if time != 0 {
            runningReadyView.setTime(time: time)
        } else {
            runningReadyView.isHidden = true
        }
    }
}
