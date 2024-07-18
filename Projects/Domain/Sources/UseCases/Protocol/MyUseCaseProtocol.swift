//
//  MyUseCaseProtocol.swift
//  Domain
//
//  Created by 유현진 on 7/15/24.
//

import Foundation
import RxSwift

protocol MyUseCaseProtocol{
    func fetchNotice() -> Observable<[NoticeModel]>
}
