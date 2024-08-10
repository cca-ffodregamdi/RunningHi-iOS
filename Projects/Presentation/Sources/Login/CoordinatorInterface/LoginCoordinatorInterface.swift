//
//  LoginCoordinatorInterface.swift
//  Presentation
//
//  Created by 유현진 on 6/5/24.
//

import Foundation
public protocol LoginCoordinatorInterface{
    func successedSignIn()
    func showAccess()
    func showAccessDetail(index: Int)
}
