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
}


extension AnnounceService: TargetType{
    public var baseURL: URL {
        return .init(string: "https://runninghi.store/api/v1")!
    }
    
    public var accessToken: String{
        return UserDefaults.standard.object(forKey: "accessToken") as! String
    }
    
    public var path: String{
        switch self{
        case .fetchAnnounce: "/alarm/all"
        }
    }
    
    public var method: Moya.Method{
        switch self{
        case .fetchAnnounce: .get
        }
    }
    
    public var task: Task{
        switch self{
        case .fetchAnnounce: .requestPlain
        }
    }
    
    public var headers: [String : String]?{
        switch self{
        case .fetchAnnounce:
            ["Content-type": "application/json",
                    "Authorization": accessToken]
        }
    }
}
