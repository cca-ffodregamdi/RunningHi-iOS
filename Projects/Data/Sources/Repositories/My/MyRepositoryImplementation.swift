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
    
    public func fetchFAQ() -> Observable<[FAQModel]> {
        return service.rx.request(.fetchFAQ)
            .filterSuccessfulStatusCodes()
            .map{ response -> [FAQModel] in
                let FAQResponse = try JSONDecoder().decode(FAQResponseDTO.self, from: response.data)
                return FAQResponse.data
            }.asObservable()
            .catch { error in
                print("MyRepositoryImplementation fetchFAQ error = \(error)")
                return Observable.error(error)
            }
    }
    
    public func fetchFeedback() -> Observable<[FeedbackModel]> {
        return service.rx.request(.fetchFeedback)
            .filterSuccessfulStatusCodes()
            .map{ response -> [FeedbackModel] in
                let feedbackResponse = try JSONDecoder().decode(FeedbackResponseDTO.self, from: response.data)
                return feedbackResponse.data.content
            }.asObservable()
            .catch { error in
                print("MyRepositoryImplementation fetchFeedback error = \(error)")
                return Observable.error(error)
            }
    }
}
