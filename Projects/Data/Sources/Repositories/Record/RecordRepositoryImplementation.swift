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

public class RecordRepositoryImplementation: RecordRepositoryProtocol {

    private let service = MoyaProvider<RecordService>()
    
    var disposeBag: DisposeBag = DisposeBag()
    
    public init(){ }
    
    public func fetchRecordData(type: RecordChartType, date: Date) -> Observable<RecordData> {
        return service.rx.request(.fetchRecord(type: type, date: date.convertDateToFormat(format: "YYYY-MM-dd")))
            .filterSuccessfulStatusCodes()
            .map{ response -> RecordData in
                let recordResponse = try JSONDecoder().decode(RecordResponseDTO.self, from: response.data)
                return recordResponse.data.toEntity(chartType: type, date: date)
            }
            .asObservable()
            .catch{ error in
                return Observable.error(error)
            }
    }
    
    public func fetchRecordDetailData(postNo: Int) -> Observable<RunningResult> {
        return service.rx.request(.fetchRunning(postNo: postNo))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .flatMap { response -> Observable<RunningResult> in
                do {
                    let recordResponse = try JSONDecoder().decode(RecordDetailResponseDTO.self, from: response.data)
                    var runningResult = recordResponse.data.toEntity(postNo: postNo)

                    return self.getRunningRouteData(url: recordResponse.data.gpsUrl ?? "")
                        .map { gpsData in
                            runningResult.routeList = gpsData.gpsData?.compactMap { data in
                                return RouteInfo(latitude: Double(data.lat) ?? 0.0,
                                                 longitude: Double(data.lon) ?? 0.0,
                                                 timestamp: Date.formatDateStringToDate(dateString: data.time) ?? Date())
                            } ?? []
                            runningResult.sectionPace = gpsData.sectionData?.pace ?? []
                            runningResult.sectionKcal = gpsData.sectionData?.kcal ?? []
                            
                            return runningResult
                        }
                } catch {
                    return Observable.error(error)
                }
            }
            .catch { error in
                return Observable.error(error)
            }
    }
    
    private func getRunningRouteData(url: String) -> Observable<RunningResultDTO> {
        return service.rx.request(.fetchGPSData(url: url))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .map(RunningResultDTO.self)
    }
    
    public func deleteRunningRecord(postNo: Int) -> Observable<Void> {
        return service.rx.request(.deleteRecord(postNo: postNo))
            .filterSuccessfulStatusCodes()
            .map{ response -> Void in
                let recordResponse = try JSONDecoder().decode(RecordDeleteResponseDTO.self, from: response.data)
                return
            }
            .asObservable()
            .catch{ error in
                return Observable.error(error)
            }
    }
}
