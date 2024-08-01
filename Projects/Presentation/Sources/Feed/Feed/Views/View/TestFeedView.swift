//
//  TestFeedView.swift
//  Presentation
//
//  Created by 유현진 on 7/31/24.
//

import UIKit
import SnapKit

class TestFeedView: UIView {
    lazy var feedFilterView: FeedFilterView = {
        return FeedFilterView()
    }()
    
    lazy var feedCollectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.contentInset = UIEdgeInsets(top: 4, left: 9, bottom: 9, right: 9)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.addSubview(feedFilterView)
        self.addSubview(feedCollectionView)
        
        feedFilterView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(32)
        }
        
        feedCollectionView.snp.makeConstraints { make in
            make.top.equalTo(feedFilterView.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
