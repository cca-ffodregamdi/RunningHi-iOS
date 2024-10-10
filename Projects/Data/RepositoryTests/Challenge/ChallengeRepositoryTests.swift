//
//  ChallengeRepositoryTests.swift
//  RepositoryTests
//
//  Created by 유현진 on 10/8/24.
//

import XCTest
import Data
import Moya
import Domain
import RxSwift
import RxCocoa

final class ChallengeRepositoryTests: XCTestCase {

    private var disposeBag: DisposeBag!
    
    override func setUp() async throws {
        
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        disposeBag = DisposeBag()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func setUp() {
        
    }

    override func tearDown() {
        
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        disposeBag = nil
    }
    
    override func tearDown() async throws {
        
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func makeStub(statusCode: Int) -> MoyaProvider<ChallengeService>{
        let endpointClosure = { (target: ChallengeService) -> Endpoint in
            let fakeHeader = ["Authorization": "Bearer dummyToken", "Content-Type": "application/json"]
            return Endpoint(url: target.path,
                            sampleResponseClosure: {.networkResponse(statusCode, target.sampleData)},
                            method: target.method,
                            task: target.task,
                            httpHeaderFields: fakeHeader)
        }
        return MoyaProvider<ChallengeService>(endpointClosure: endpointClosure,
                                              stubClosure: MoyaProvider.immediatelyStub)
    }
    
    func test_fetchChallenge_성공(){
        let expectation = XCTestExpectation(description: "fetchChallenge 성공\n")
        let stub = makeStub(statusCode: 200)
        stub.rx.request(.fetchChallenge(status: .COMPLETED))
            .subscribe(onSuccess: { response in
                XCTAssertEqual(response.statusCode, 200) // 의도한 statusCode인가
                expectation.fulfill()
            }, onFailure: { error in
                XCTFail("Error should not occur: \(error)") // 문제는 없는가
            })
            .disposed(by: disposeBag)
        wait(for: [expectation], timeout: 0.5)
    }
}
