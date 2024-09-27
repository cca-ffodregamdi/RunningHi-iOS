//
//  TabBarUseCase.swift
//  Domain
//
//  Created by 유현진 on 9/27/24.
//

import Foundation
import RxSwift

public protocol TabBarUseCaseProtocol{
    func uploadFCMToken(fcmToken: String) -> Single<Void>
}
