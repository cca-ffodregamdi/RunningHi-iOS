//
//  RankHeaderFooterView.swift
//  Presentation
//
//  Created by 유현진 on 5/31/24.
//

import UIKit
import SnapKit
import Domain
import Common

class RankHeaderFooterView: UITableViewHeaderFooterView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "랭킹"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        stackView.alignment = .bottom
        return stackView
    }()

    private lazy var leftRankView: RankHeaderElementView = {
        let view = RankHeaderElementView()
        return view
    }()
    
    private lazy var centerRankView: RankHeaderElementView = {
        let view = RankHeaderElementView()
        return view
    }()
    
    private lazy var rightRankView: RankHeaderElementView = {
        let view = RankHeaderElementView()
        return view
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.addSubview(titleLabel)
        
        [leftRankView, centerRankView, rightRankView].forEach{
            self.stackView.addArrangedSubview($0)
        }
        self.addSubview(stackView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10).priority(.high)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20).priority(.high)
        }
    }
    
    func configureModel(models: [RankModel]){
        self.titleLabel.text = "랭킹"
        models.forEach{
            if $0.rank == 1{
                self.centerRankView.isFirstRanker()
                self.centerRankView.configureModel(model: $0)
            }else if $0.rank == 2{
                self.leftRankView.configureModel(model: $0)
            }else{
                self.rightRankView.configureModel(model: $0)
            }
        }
    }
}
