//
//  AnnounceUseCase.swift
//  Domain
//
//  Created by 유현진 on 8/5/24.
//

import Foundation
import RxSwift

public final class AnnounceUseCase: AnnounceUseCaseProtocol{
    private let repository:  AnnounceRespositoryProtocol
    
    public init(repository: AnnounceRespositoryProtocol) {
        self.repository = repository
    }
    
    public func fetchAnnounce() -> Observable<[AnnounceModel]> {
        return repository.fetchAnnounce()
    }
}
