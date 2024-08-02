//
//  FeedView.swift
//  Presentation
//
//  Created by 유현진 on 7/27/24.
//

import UIKit
import Common
import SnapKit

public class FeedView: UIView {
    lazy var feedCollectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.contentInset = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
        collectionView.backgroundColor = .clear
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
        self.addSubview(feedCollectionView)
        
        feedCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
