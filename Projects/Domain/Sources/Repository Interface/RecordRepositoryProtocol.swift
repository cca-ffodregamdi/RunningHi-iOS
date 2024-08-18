//
//  RecordRepositoryProtocol.swift
//  Domain
//
//  Created by najin on 7/21/24.
//

import Foundation
import RxSwift

public protocol RecordRepositoryProtocol {
    func fetchRecordData(type: RecordChartType, date: Date) -> Observable<RecordData>
    func fetchRecordDetailData(postNo: Int) -> Observable<RunningResult>
}
