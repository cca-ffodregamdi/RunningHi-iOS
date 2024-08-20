//
//  ChallengeCoordinatorInterface.swift
//  Presentation
//
//  Created by 유현진 on 6/5/24.
//

import Foundation
import Domain

public protocol ChallengeCoordinatorInterface{
    func showChallengeDetailView(viewController: ChallengeViewController, challengeId: Int, isParticipated: Bool)
    func showAnnounce()
}
