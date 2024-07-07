//
//  TabBarCoordinatorInterface.swift
//  Presentation
//
//  Created by najin on 7/2/24.
//

import UIKit
import Domain

public protocol TabBarCoordinatorInterface {
    func showRunningPopup(_ viewController: UIViewController)
    func cancelRunningPopup(_ viewController: UIViewController)
    func showRunning(isFreeCourse: Bool)
}
