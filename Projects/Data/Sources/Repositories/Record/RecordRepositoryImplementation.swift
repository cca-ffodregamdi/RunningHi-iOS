//
//  RecordRepositoryImplementation.swift
//  Data
//
//  Created by najin on 7/21/24.
//

import Foundation
import Domain
import RxSwift
import CoreLocation
import Moya
import RxMoya

public class RecordRepositoryImplementation: RecordRepositoryProtocol {

    private let service = MoyaProvider<RunningService>()
    
    var disposeBag: DisposeBag = DisposeBag()
    
    public init(){ }
}
