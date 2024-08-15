//
//  KeyChain.swift
//  Domain
//
//  Created by 유현진 on 8/10/24.
//

import Foundation
import Security
import Domain

public class KeyChainManager{
    
    public class func create(key: KeyChainKeys, token: String){
        let query: NSDictionary = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrAccount : key.rawValue,
            kSecValueData : token.data(using: .utf8, allowLossyConversion: false) as Any
        ]
        
        SecItemDelete(query)
        
        let status = SecItemAdd(query, nil)
        assert(status == noErr, "failed to save token")
    }
    
    public class func read(key: KeyChainKeys) -> String?{
        let query: NSDictionary = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrAccount : key.rawValue,
            kSecReturnData : kCFBooleanTrue as Any,
            kSecMatchLimit : kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        
        if status == errSecSuccess {
            if let retrievedData: Data = dataTypeRef as? Data {
                let value = String(data: retrievedData, encoding: String.Encoding.utf8)
                return value
            }else { return nil }
        } else {
            print("failed to loading, status code = \(status)")
            return nil
        }
    }
    
    public class func delete(key: KeyChainKeys){
        let query: NSDictionary = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrAccount : key.rawValue
        ]
        
        let status = SecItemDelete(query)
        assert(status == noErr, "failed to delete the value, status code = \(status)")
    }
}
