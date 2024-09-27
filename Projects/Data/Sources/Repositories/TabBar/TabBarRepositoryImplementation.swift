//
//  TabBarRepositoryImplementation.swift
//  Data
//
//  Created by 유현진 on 9/27/24.
//

import Foundation
import Domain
import RxSwift
import Moya
import RxMoya

public final class TabBarRepositoryImplementation: TabBarRepositoryProtocol{
    
    private let service = MoyaProvider<TabBarService>()
    
    public init(){ }
    
    public func uploadFCMToken(fcmToken: String) -> Single<Void> {
        return service.rx.request(.uploadFCMToken(fcmToken))
            .filterSuccessfulStatusCodes()
            .map{_ in}
            
            
    }
}
