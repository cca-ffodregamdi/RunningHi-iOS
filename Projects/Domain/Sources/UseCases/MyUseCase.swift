//
//  MyUseCase.swift
//  Domain
//
//  Created by 유현진 on 7/15/24.
//

import Foundation

public final class MyUseCase: MyUseCaseProtocol{
    private let repository:  MyRepositoryProtocol
    
    public init(repository: MyRepositoryProtocol) {
        self.repository = repository
    }
}
