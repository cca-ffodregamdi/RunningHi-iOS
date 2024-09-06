//
//  FAQResponseDTO.swift
//  Data
//
//  Created by 유현진 on 9/6/24.
//

import Foundation
import Domain

public struct FAQResponseDTO: Decodable{
    let timeStamp: String
    let status: String
    let message: String
    public let data: [FAQResponseModel]
}

public struct FAQResponseModel: Decodable{
    public let faqNo: Int
    public let question: String?
    public let answer: String?
    
    func toEntity() -> FAQModel{
        return FAQModel(faqId: faqNo,
                        question: question ?? "",
                        answer: answer ?? "")
    }
}
