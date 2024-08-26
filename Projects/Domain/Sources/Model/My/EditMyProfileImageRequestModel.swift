//
//  EditMyProfileImageRequest.swift
//  Domain
//
//  Created by 유현진 on 8/26/24.
//

import Foundation

public struct EditMyProfileImageRequestModel: Codable{
    public let imageData: Data
    
    public init(jpegData: Data) {
        self.imageData = jpegData
    }
}
