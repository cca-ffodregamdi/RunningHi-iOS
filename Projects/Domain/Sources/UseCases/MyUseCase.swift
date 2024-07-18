//
//  MyUseCase.swift
//  Domain
//
//  Created by 유현진 on 7/15/24.
//

import Foundation
import RxSwift

public final class MyUseCase: MyUseCaseProtocol{
    private let repository:  MyRepositoryProtocol
    
    public init(repository: MyRepositoryProtocol) {
        self.repository = repository
    }
    
    public func fetchNotice() -> Observable<[NoticeModel]> {
        self.repository.fetchNotice()
    }
}
