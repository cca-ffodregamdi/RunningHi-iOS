//
//  MyRepositoryImplementation.swift
//  Data
//
//  Created by 유현진 on 7/15/24.
//

import Foundation
import Domain
import Moya
import RxMoya
import RxSwift

public final class MyRepositoryImplementation: MyRepositoryProtocol{
    private let service = MoyaProvider<MyService>()
    
    public init() { }
    
    public func fetchNotice() -> Observable<[NoticeModel]> {
        return service.rx.request(.fetchNotice)
            .filterSuccessfulStatusCodes()
            .map{ response -> [NoticeModel] in
                let noticesResponse = try JSONDecoder().decode(NoticeResponseDTO.self, from: response.data)
                return noticesResponse.data.content
            }.asObservable()
            .catch { error in
                print("MyRepositoryImplementation fetchNotice error = \(error)")
                return Observable.error(error)
            }
    }
}
