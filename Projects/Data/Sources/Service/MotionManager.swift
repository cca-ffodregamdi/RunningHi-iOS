//
//  MotionManager.swift
//  Data
//
//  Created by 오영석 on 6/3/24.
//

import Foundation
import CoreMotion

enum MotionActivity {
    case stationary
    case walking
    case running
    case automotive
    case cycling
    case unknown
}

class MotionManager {
    let motionManager = CMMotionActivityManager()
    var currentMotion: MotionActivity = .running
    
    func checkMotionActivity() -> MotionActivity {
        guard CMMotionActivityManager.isActivityAvailable() else {
            return currentMotion
        }
        
        motionManager.startActivityUpdates(to: OperationQueue.main) { [weak self] activity in
            guard let self = self, let activity = activity else { return }
            
            var newMotion: MotionActivity = .unknown
            
            switch true {
            case activity.stationary:
                newMotion = .stationary
            case activity.walking:
                newMotion = .walking
            case activity.running:
                newMotion = .running
            case activity.automotive:
                newMotion = .automotive
            case activity.cycling:
                newMotion = .cycling
            default:
                newMotion = .unknown
            }
            
            currentMotion = newMotion
        }
        
        return currentMotion
    }
}
