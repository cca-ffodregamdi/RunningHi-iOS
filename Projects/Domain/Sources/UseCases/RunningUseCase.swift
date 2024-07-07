//
//  RunningUseCase.swift
//  Domain
//
//  Created by najin on 7/7/24.
//

import Foundation
import RxSwift

public final class RunningUseCase: RunningUseCaseProtocol{
    
    private let repository: RunningRepositoryProtocol

    public init(repository: RunningRepositoryProtocol) {
        self.repository = repository
    }
}
