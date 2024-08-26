//
//  EditProfileImageRequestDTO.swift
//  Data
//
//  Created by 유현진 on 8/26/24.
//

import Foundation
import Domain
import Moya

public struct EditProfileImageRequestDTO: Codable{
    
    let data: EditMyProfileImageRequestModel
    
    public init(data: EditMyProfileImageRequestModel) {
        self.data = data
    }
    
    func toRequsetMutipartFormData() -> MultipartFormData{
        return MultipartFormData(provider: .data(data.imageData), name: "file", fileName: "fileName.jpeg", mimeType: "image/jpeg")
    }
}
