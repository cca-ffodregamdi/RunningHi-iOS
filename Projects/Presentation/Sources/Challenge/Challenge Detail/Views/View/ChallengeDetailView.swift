//
//  ChallengeDetailView.swift
//  Presentation
//
//  Created by 유현진 on 9/6/24.
//

import UIKit
import Common
import SnapKit

class ChallengeDetailView: UIView {

    lazy var headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var joinButton: UIButton = {
        let button = UIButton()
        button.setTitle("참여하기", for: .normal)
        button.setTitleColor(.BaseWhite, for: .normal)
        button.backgroundColor = .Primary
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = false
        scrollView.backgroundColor = .white
        scrollView.clipsToBounds = true
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    lazy var challengeDetailInfoView: ChallengeDetailInfoView = {
        return ChallengeDetailInfoView()
    }()
    
    lazy var infoRankBreakLine: UIView = {
        let view = UIView()
        view.backgroundColor = .Neutrals100
        return view
    }()
    
    lazy var rankTableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(RankTableViewCell.self, forCellReuseIdentifier: RankTableViewCell.identifier)
        tableView.register(RankHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: RankHeaderFooterView.identifier)
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderTopPadding = 0
        return tableView
    }()
    
    lazy var myRankView: MyRankView = {
        return MyRankView()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.addSubview(scrollView)
        self.scrollView.addSubview(headerImageView)
        self.scrollView.addSubview(challengeDetailInfoView)
        self.scrollView.addSubview(infoRankBreakLine)
        self.scrollView.addSubview(rankTableView)
        self.addSubview(joinButton)
        self.addSubview(myRankView)
        
        scrollView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        headerImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height / 3)
        }
        
        challengeDetailInfoView.snp.makeConstraints { make in
            make.top.equalTo(headerImageView.snp.bottom)
            make.left.right.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        infoRankBreakLine.snp.makeConstraints { make in
            make.top.equalTo(challengeDetailInfoView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(8)
        }
        
        rankTableView.snp.makeConstraints { make in
            make.top.equalTo(infoRankBreakLine.snp.bottom)
            make.left.right.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview().offset(-40)
            make.height.equalTo(rankTableView.contentSize.height)
        }
        
        joinButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-30)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(45)
        }
        
        myRankView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(58)
        }
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        joinButton.layer.cornerRadius = joinButton.bounds.height * 0.5
    }
}
