//
//  RecordUseCase.swift
//  Domain
//
//  Created by najin on 7/21/24.
//

import Foundation
import RxSwift

public final class RecordUseCase: RecordUseCaseProtocol {
    
    private let repository: RecordRepositoryProtocol
    
    private let disposeBag = DisposeBag()

    public init(repository: RecordRepositoryProtocol) {
        self.repository = repository
    }
}
