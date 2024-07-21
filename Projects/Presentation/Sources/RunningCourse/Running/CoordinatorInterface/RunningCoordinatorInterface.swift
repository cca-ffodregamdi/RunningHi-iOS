//
//  RunningCoordinatorInterface.swift
//  Presentation
//
//  Created by najin on 7/7/24.
//

import Foundation
import Domain

public protocol RunningCoordinatorInterface {
    func showRunningResult(runningResult: RunningResult)
    func finishRunning()
}
