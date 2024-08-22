//
//  AnnounceUseCaseProtocol.swift
//  Domain
//
//  Created by 유현진 on 8/5/24.
//

import Foundation
import RxSwift

public protocol AnnounceUseCaseProtocol{
    func fetchAnnounce() -> Observable<[AnnounceModel]>
    func deleteAnnounce(announceId: Int) -> Observable<Any>
}
