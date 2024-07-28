//
//  RecordRepositoryImplementation.swift
//  Data
//
//  Created by najin on 7/21/24.
//

import Foundation
import Domain
import RxSwift
import CoreLocation
import Moya
import RxMoya
import Common

public class RecordRepositoryImplementation: RecordRepositoryProtocol {

    private let service = MoyaProvider<RecordService>()
    
    var disposeBag: DisposeBag = DisposeBag()
    
    public init(){ }
    
    public func fetchRecordData(type: RecordChartType, date: Date) -> Observable<RecordData> {
        return service.rx.request(.fetchRecord(type: type, date: date.convertDateToFormat(format: "YYYY-MM-dd")))
            .filterSuccessfulStatusCodes()
            .map{ response -> RecordData in
                let recordResponse = try JSONDecoder().decode(RecordResponseDTO.self, from: response.data)
                return recordResponse.data.toEntity
            }
            .asObservable()
            .catch{ error in
                print("RecordRepositoryImplementation fetchRecord error = \(error)")
                return Observable.error(error)
            }
    }
}
