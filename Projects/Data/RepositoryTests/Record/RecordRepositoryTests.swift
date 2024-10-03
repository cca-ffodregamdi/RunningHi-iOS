//
//  RecordRepositoryTests.swift
//  RepositoryTests
//
//  Created by najin on 10/3/24.
//

import XCTest
import RxSwift
import Moya
import RxMoya
import Data
import Domain

final class RecordRepositoryTests: XCTestCase {

    // MARK: - Properties

    private let service = MoyaProvider<RecordService>()
    private var disposeBag: DisposeBag = DisposeBag()

    // MARK: - Lifecycle

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - Helper

    func test_fetch_record_data() throws {
//        service.rx.request(.fetchRecord(type: .weekly, date: "2020-01-01"))
//            .filterSuccessfulStatusCodes()
//            .map{ response -> RecordData in
//                let recordResponse = try JSONDecoder().decode(RecordResponseDTO.self, from: response.data)
//                XCTAssertEqual(recordResponse.data.meanPace, 0)
//                return Observable.just(RecordData(chartType: .weekly,
//                                                  date: Date(),
//                                                  chartDatas: [],
//                                                  runCnt: 0,
//                                                  totalTime: 0,
//                                                  meanPace: 0,
//                                                  totalKcal: 0,
//                                                  runningRecords: [])
//                )
//            }
//            .asObservable()
//            .catch{ error in
//                return Observable.error(error)
//            }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
