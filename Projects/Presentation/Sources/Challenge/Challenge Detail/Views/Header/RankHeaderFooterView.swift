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
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.alignment = .lastBaseline
        return stackView
    }()

    private lazy var leftRankView: RankHeaderElementView = {
        let view = RankHeaderElementView()
        view.backgroundColor = UIColor.colorWithRGB(r: 188, g: 201, b: 244)
        return view
    }()
    
    private lazy var centerRankView: RankHeaderElementView = {
        let view = RankHeaderElementView()
        view.backgroundColor = UIColor.colorWithRGB(r: 34, g: 101, b: 201)
        return view
    }()
    
    private lazy var rightRankView: RankHeaderElementView = {
        let view = RankHeaderElementView()
        view.backgroundColor = UIColor.colorWithRGB(r: 188, g: 201, b: 244)
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
        self.addSubview(stackView)
        [leftRankView, centerRankView, rightRankView].forEach{
            self.stackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(20)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20).priority(.high)
            make.right.equalToSuperview().offset(-20).priority(.high)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        leftRankView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        centerRankView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(leftRankView.snp.right).offset(15).priority(.high)
            make.right.equalTo(rightRankView.snp.left).offset(-15).priority(.high)
            make.bottom.equalToSuperview()
        }
        rightRankView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func configureModel(models: [RankModel]){
        self.titleLabel.text = "랭킹"
        models.forEach{
            if $0.rank == 1{
                self.centerRankView.configureModel(model: $0)
            }else if $0.rank == 2{
                self.leftRankView.configureModel(model: $0)
            }else{
                self.rightRankView.configureModel(model: $0)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        [centerRankView, leftRankView, rightRankView].forEach{
            $0.layer.cornerRadius = $0.bounds.width * 0.25
        }
    }
}
