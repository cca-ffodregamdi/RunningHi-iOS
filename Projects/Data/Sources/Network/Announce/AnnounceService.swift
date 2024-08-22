//
//  AnnounceService.swift
//  Data
//
//  Created by 유현진 on 8/5/24.
//

import Foundation
import Moya
import RxSwift
import Domain

public enum AnnounceService{
    case fetchAnnounce
    case deleteAnnounce(announceId: Int)
}


extension AnnounceService: TargetType{
    public var baseURL: URL {
        return .init(string: "https://runninghi.store/api/v1")!
    }
    
    public var accessToken: String{
        return KeyChainManager.read(key: .runningHiAccessTokenkey)!
    }
    
    public var path: String{
        switch self{
        case .fetchAnnounce: "/alarm/all"
        case .deleteAnnounce(let announceId): "/alarm/\(announceId)"
        }
    }
    
    public var method: Moya.Method{
        switch self{
        case .fetchAnnounce: .get
        case .deleteAnnounce: .delete
        }
    }
    
    public var task: Task{
        switch self{
        case .fetchAnnounce, .deleteAnnounce: .requestPlain
        }
    }
    
    public var headers: [String : String]?{
        switch self{
        case .fetchAnnounce,
                .deleteAnnounce:
            ["Content-type": "application/json",
                    "Authorization": accessToken]
        }
    }
}
