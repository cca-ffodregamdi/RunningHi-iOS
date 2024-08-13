//
//  UserDefaultsManager.swift
//  Domain
//
//  Created by 유현진 on 8/10/24.
//

import Foundation
public class UserDefaultsManager{
    
    public enum Keys: String{
        case loginTypeKey = "loginType"
    }
    
    public static func set<T>(to: T, forKey: Keys){
        UserDefaults.standard.setValue(to, forKey: forKey.rawValue)
    }
    
    public static func get(forKey: Keys) -> Any?{
        return UserDefaults.standard.object(forKey: forKey.rawValue)
    }
}
