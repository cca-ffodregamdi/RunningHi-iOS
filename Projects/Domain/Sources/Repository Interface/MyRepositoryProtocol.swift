//
//  MyRepositoryProtocol.swift
//  Domain
//
//  Created by 유현진 on 7/15/24.
//

import Foundation
import RxSwift

public protocol MyRepositoryProtocol{
    func fetchNotice() -> Observable<[NoticeModel]>
    func fetchFAQ() -> Observable<[FAQModel]>
    func fetchFeedback() -> Observable<[FeedbackModel]>
}
