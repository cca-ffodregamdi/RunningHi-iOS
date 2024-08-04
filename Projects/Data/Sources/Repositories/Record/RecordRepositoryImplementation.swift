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
                var data = recordResponse.data.toEntity(chartType: type, date: date)
                // TestCase
//                if type == .weekly {
//                    data.chartDatas = (0..<7).map { _ in Double.random(in: 0...5.0) }
//                } else if type == .monthly {
//                    data.chartDatas = (0..<31).map { _ in Double.random(in: 0...10.0) }
//                } else {
//                    data.chartDatas = (0..<12).map { _ in Double.random(in: 0...50.0) }
//                }
                return data
            }
            .asObservable()
            .catch{ error in
                print("RecordRepositoryImplementation fetchRecord error = \(error)")
                return Observable.error(error)
            }
    }
}
