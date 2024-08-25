//
//  FeedEditView.swift
//  Presentation
//
//  Created by najin on 8/25/24.
//

import UIKit
import SnapKit
import Domain
import Common

class FeedEditView: UIView {
    
    //MARK: - Configure
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.addSubview(stackView)
        return scrollView
    }()
    
    private var contentTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "내용"
        label.font = .Subhead
        label.textColor = .black
        return label
    }()
    
    var contentTextView = FeedEditTextView()
    
    private var representTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "대표 기록"
        label.font = .Subhead
        label.textColor = .black
        return label
    }()
    
    var representDistanceButton = FeedRepresentButton(title: FeedRepresentType.distance.rawValue)
    var representTimeButton = FeedRepresentButton(title: FeedRepresentType.time.rawValue)
    var representPaceButton = FeedRepresentButton(title: FeedRepresentType.pace.rawValue)
    var representKcalButton = FeedRepresentButton(title: FeedRepresentType.kcal.rawValue)
    var representNoneButton = FeedRepresentButton(title: FeedRepresentType.none.rawValue)
    var representEmptyButton = FeedRepresentButton()
    
    private lazy var representButtonStackView1 = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        stackView.addArrangedSubview(representDistanceButton)
        stackView.addArrangedSubview(representTimeButton)
        stackView.addArrangedSubview(representPaceButton)
        return stackView
    }()
    
    private lazy var representButtonStackView2 = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        stackView.addArrangedSubview(representKcalButton)
        stackView.addArrangedSubview(representNoneButton)
        stackView.addArrangedSubview(representEmptyButton)
        return stackView
    }()
    
    private lazy var stackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 11
        
        stackView.addArrangedSubview(contentTitleLabel)
        stackView.addArrangedSubview(contentTextView)
        stackView.addArrangedSubview(representTitleLabel)
        stackView.addArrangedSubview(representButtonStackView1)
        stackView.addArrangedSubview(representButtonStackView2)
        return stackView
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        congifureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        congifureUI()
    }
    
    //MARK: - Configure
    
    private func congifureUI() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalTo(safeAreaLayoutGuide)
            make.left.right.equalToSuperview().inset(20)
        }
        
        stackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        
        contentTextView.snp.makeConstraints { make in
            make.height.equalTo(140)
        }
    }
    
    //MARK: - Helpers
    
    func setRepresentType(type: FeedRepresentType) {
        representDistanceButton.setActiveButton(isActive: type == .distance)
        representTimeButton.setActiveButton(isActive: type == .time)
        representPaceButton.setActiveButton(isActive: type == .pace)
        representKcalButton.setActiveButton(isActive: type == .kcal)
        representNoneButton.setActiveButton(isActive: type == .none)
    }
}
