//
//  RunningRepositoryImplementation.swift
//  Data
//
//  Created by najin on 7/7/24.
//

import Foundation
import Domain
import KakaoSDKAuth
import RxKakaoSDKUser
import KakaoSDKUser
import RxSwift
import Moya
import RxMoya

public class RunningRepositoryImplementation: RunningRepositoryProtocol{

    public init(){
        
    }
    
    deinit{
        print("deinit LoginRepositoryImplementation")
    }
}

