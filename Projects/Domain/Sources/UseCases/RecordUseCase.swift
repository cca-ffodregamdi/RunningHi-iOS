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
    
    public func fetchRecordData(type: RecordChartType, date: Date) -> Observable<RecordData> {
        return repository.fetchRecordData(type: type, date: date)
    }
}
