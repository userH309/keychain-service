//
//  KeychainService.swift
//
//
//  Created by Erik Andresen on 04/10/2019.
//  Copyright © 2019 Shortcut. All rights reserved.
//

import Security
import Foundation

private let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)
private let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
private let kSecClassValue = NSString(format: kSecClass)
private let kSecAttrServiceValue = NSString(format: kSecAttrService)
private let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
private let kSecValueDataValue = NSString(format: kSecValueData)
private let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
private let kSecReturnDataValue = NSString(format: kSecReturnData)

public class KeychainService: NSObject {
    let account: String
    
    public init(forUserAccount account: String) {
        self.account = account
    }
    
    public func saveItem(item: String, forKey key: String) -> Bool {
        if let itemData = item.data(using: .utf8, allowLossyConversion: false) {
            let keychainQuery = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, key, account, itemData], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])
            SecItemDelete(keychainQuery)
            let status = SecItemAdd(keychainQuery as CFDictionary, nil)
            if status == errSecSuccess {
                print(status)
                return true
            }
            print(status)
            
        }
        return false
    }
    
    public func loadItem(forKey key: String) -> (String?) {
        let keychainQuery = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, key, account, kCFBooleanTrue!, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
        var dataTypeRef: AnyObject?
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? Data {
                let itemFromKeychain = String(data: retrievedData, encoding: .utf8) ?? ""
                return itemFromKeychain
            }
        }
        return nil
    }
//
//    func removeItems(for keys: [String]) {
//        for key in keys {
//            let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [genericPasswordItem, key, userAccount, kCFBooleanTrue!, kSecMatchLimitOne], forKeys: [itemClass, itemService, itemAccount, returnItemData, matchLimitOneItem])
//            let status = SecItemDelete(keychainQuery)
//            print("KeychainService: Tokens removed from keychain, status \(status)")
//        }
//    }
}

