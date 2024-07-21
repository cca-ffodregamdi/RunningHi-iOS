//
//  FAQResponseDTO.swift
//  Domain
//
//  Created by 유현진 on 7/18/24.
//

import Foundation

public struct FAQResponseDTO: Decodable{
    let timeStamp: String
    let status: String
    let message: String
    public let data: [FAQModel]
}

public struct FAQModel: Decodable{
    public let faqId: Int
    public let question: String
    public let answer: String
    
    enum CodingKeys: String, CodingKey {
        case faqId = "faqNo"
        case question
        case answer
    }
}
