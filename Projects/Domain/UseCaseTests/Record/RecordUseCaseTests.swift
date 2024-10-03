//
//  RecordUseCaseTests.swift
//  UseCaseTests
//
//  Created by najin on 10/3/24.
//

import XCTest
import Domain
import RxSwift
import RxTest

// XCTest를 이용한 Unit test
final class RecordUseCaseTests: XCTestCase {
    
    // MARK: - Properties
    
    private var scheduler: TestScheduler!
    private var useCase: RecordUseCase!
    private var disposeBag: DisposeBag!

    // MARK: - Lifecycle
    
    override func setUpWithError() throws {
        self.scheduler = TestScheduler(initialClock: 0)
//        self.useCase = RecordUseCase(repository: MockRecordRepository())
        self.disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        self.scheduler = nil
        self.useCase = nil
        self.disposeBag = nil
    }

    // MARK: - TestCases
    
    func test_check_fetching() {
        
    }
}
