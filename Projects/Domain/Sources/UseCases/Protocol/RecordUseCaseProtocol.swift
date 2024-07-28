//
//  RecordUseCaseProtocol.swift
//  Domain
//
//  Created by najin on 7/21/24.
//

import Foundation
import RxSwift
import KakaoSDKAuth

public protocol RecordUseCaseProtocol{
    func fetchRecordData(type: RecordChartType, date: Date) -> Observable<RecordData>
}
