//
//  AnnounceRepositoryImplementation.swift
//  Data
//
//  Created by 유현진 on 8/5/24.
//

import Foundation
import Domain
import RxSwift
import Moya
import RxMoya

final public class AnnounceRepositoryImplementation: AnnounceRespositoryProtocol{
    
    private let service = MoyaProvider<AnnounceService>()
    
    public init(){ }
    
    public func fetchAnnounce() -> Observable<[AnnounceModel]> {
        return service.rx.request(.fetchAnnounce)
            .filterSuccessfulStatusCodes()
            .map{ response -> [AnnounceModel] in
                let announceResponse = try JSONDecoder().decode(AnnounceResponseDTO.self, from: response.data)
                return announceResponse.data
            }.asObservable()
            .catch{ error in
                print("AnnounceRepositoryImplementation fetchAnnounce error: \(error)")
                return Observable.error(error)
            }
    }
}
