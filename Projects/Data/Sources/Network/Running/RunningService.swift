//
//  RunningService.swift
//  Data
//
//  Created by najin on 7/21/24.
//

import Foundation
import Moya
import RxSwift
import Domain

public enum RunningService {
    case saveRunningResult(data: String)
}

extension RunningService: TargetType {
    public var baseURL: URL {
        return .init(string: "https://runninghi.store/api/v1")!
    }
    
    public var accessToken: String {
        return KeyChainManager.read(key: .runningHiAccessTokenkey)!
    }
    
    public var path: String {
        switch self {
        case .saveRunningResult:
            return "/posts/gps"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .saveRunningResult:
            return .post
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .saveRunningResult(let data):
            var multipartData = [MultipartFormData]()
            
            if let fileData = data.data(using: .utf8) {
                multipartData.append(MultipartFormData(provider: .data(fileData), name: "file", fileName: "fileName", mimeType: "text/plain"))
            }
            
            return .uploadMultipart(multipartData)
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .saveRunningResult:
            return ["Content-type": "multipart/form-data",
                    "Authorization": accessToken]
        }
    }
}
