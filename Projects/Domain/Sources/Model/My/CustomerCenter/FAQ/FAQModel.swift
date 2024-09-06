//
//  FAQResponseDTO.swift
//  Domain
//
//  Created by 유현진 on 7/18/24.
//

import Foundation

public struct FAQModel{
    public let faqId: Int
    public let question: String
    public let answer: String
    
    public init(faqId: Int, question: String, answer: String) {
        self.faqId = faqId
        self.question = question
        self.answer = answer
    }
}
