//
//  ChallengeView.swift
//  Presentation
//
//  Created by 유현진 on 8/15/24.
//

import UIKit
import SnapKit
import Common

class ChallengeView: UIView {

    lazy var challengeCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(ChallengeCollectionViewCell.self, forCellWithReuseIdentifier: ChallengeCollectionViewCell.identifier)
        collectionView.register(ChallengeCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ChallengeCollectionReusableView.identifier)
        collectionView.backgroundColor = .Secondary100
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.addSubview(challengeCollectionView)
        
        challengeCollectionView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(15)
        }
    }
}
