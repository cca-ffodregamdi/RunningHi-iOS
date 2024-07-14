//
//  MyRepositoryImplementation.swift
//  Data
//
//  Created by 유현진 on 7/15/24.
//

import Foundation
import Domain
import Moya
import RxMoya

public final class MyRepositoryImplementation: MyRepositoryProtocol{
    private let service = MoyaProvider<ChallengeService>()
    
    public init() { }
}
