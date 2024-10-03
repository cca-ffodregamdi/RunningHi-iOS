//
//  RecordReactorSpec.swift
//  ReactorTests
//
//  Created by najin on 10/3/24.
//

import XCTest
import RxSwift
import Quick
import Nimble
import RxTest
import Presentation
import Domain

final class RecordReactorSpec: QuickSpec {
    override class func spec() {
        describe("RecordReactor의 테스트 코드를 실행합니다.") {
            var reactor: RecordReactor!
            var disposeBag: DisposeBag!
            
            beforeEach {
//                reactor = RecordReactor(recordUseCase: RecordUseCase(repository: MockRecordRepository()))
                disposeBag = DisposeBag()
            }
            
            it("should increase value when action increase is triggered") {
//                // 액션을 트리거
//                reactor.action.onNext(.increase)
//
//                // UseCase 호출 여부 확인
//                expect(increaseCounterUseCase.executeCallCount).toEventually(equal(1))
//
//                // 상태 확인
//                expect(reactor.currentState.value).toEventually(equal(1))
            }
        }
    }
}
