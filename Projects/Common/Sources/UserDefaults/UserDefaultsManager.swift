//
//  UserDefaultsManager.swift
//  Domain
//
//  Created by 유현진 on 8/10/24.
//

import Foundation
import Domain

public class UserDefaultsManager{
    
    public static func set<T>(to: T, forKey: UserDefaultsKeys){
        UserDefaults.standard.setValue(to, forKey: forKey.rawValue)
    }
    
    public static func get(forKey: UserDefaultsKeys) -> Any?{
        return UserDefaults.standard.object(forKey: forKey.rawValue)
    }
    
    public static func reset(){
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.loginTypeKey.rawValue)
    }
}
