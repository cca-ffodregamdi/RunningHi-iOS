//
//  SignOutReasonSection.swift
//  Presentation
//
//  Created by 유현진 on 8/24/24.
//

import Foundation
import RxDataSources

struct SignOutReasonSection{
    var items: [Item]
}

extension SignOutReasonSection: SectionModelType{
    typealias Item = SignOutReasonCase

    init(original: SignOutReasonSection, items: [Item]) {
        self = original
        self.items = items
    }
}
