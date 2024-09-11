//
//  TermsAgreementResponseDTO.swift
//  Data
//
//  Created by 유현진 on 9/10/24.
//

import Foundation

public struct TermsAgreementResponseDTO: Decodable{
    let timeStamp: String
    let status: String
    let message: String
    let data: TermsAgreementResponseModel
}

public struct TermsAgreementResponseModel: Decodable{
    let isTermsAgreed: Bool
}
