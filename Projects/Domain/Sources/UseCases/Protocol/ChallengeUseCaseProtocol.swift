//
//  ChallengeProtocol.swift
//  Domain
//
//  Created by 유현진 on 5/29/24.
//

import Foundation
import RxSwift
protocol ChallengeUseCaseProtocol{
    func getChallengeList() -> Observable<[ChallengeModel]>
    func getRank() -> Observable<[RankModel]>
}
