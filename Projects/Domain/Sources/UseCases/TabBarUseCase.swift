//
//  TabBarUseCase.swift
//  Domain
//
//  Created by 유현진 on 9/27/24.
//

import Foundation
import RxSwift

public final class TabBarUseCase: TabBarUseCaseProtocol{
    
    private let repository: TabBarRepositoryProtocol
    
    public init(repository: TabBarRepositoryProtocol) {
        self.repository = repository
    }
    
    public func uploadFCMToken(fcmToken: String) -> Single<Void> {
        return repository.uploadFCMToken(fcmToken: fcmToken)
    }
}
