//
//  AnnounceRespositoryProtocol.swift
//  Domain
//
//  Created by 유현진 on 8/5/24.
//

import Foundation
import RxSwift

public protocol AnnounceRespositoryProtocol{
    func fetchAnnounce() -> Observable<[AnnounceModel]>
}
