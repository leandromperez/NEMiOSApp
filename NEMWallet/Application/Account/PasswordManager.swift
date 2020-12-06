//
//  PasswordManager.swift
//  NEMWallet
//
//  Created by Leandro Perez on 06/12/2020.
//  Copyright © 2020 NEM. All rights reserved.
//

import Foundation

class PasswordManager {
    var applicationPassword : () -> String?
    var authenticationSalt : () -> String?
    var setAuthenticationSalt : (String) -> Void
    var setApplicationPassword : (String) -> Void
    
    static var shared : PasswordManager = {
        PasswordManager(applicationPassword: SettingsManager.sharedInstance.applicationPassword,
                       authorizationSalt: SettingsManager.sharedInstance.authenticationSalt,
                       setApplicationPassword: SettingsManager.sharedInstance.setApplicationPassword(applicationPassword:),
                       setAuthenticationSalt: SettingsManager.sharedInstance.setAuthenticationSalt(authenticationSalt:))
    }()
    
    init(applicationPassword: @escaping () -> String?,
         authorizationSalt: @escaping () -> String?,
         setApplicationPassword: @escaping (String) -> Void,
         setAuthenticationSalt: @escaping (String) -> Void) {
    
        self.applicationPassword = applicationPassword
        self.authenticationSalt = authorizationSalt
        self.setApplicationPassword = setApplicationPassword
        self.setAuthenticationSalt = setAuthenticationSalt
    }
    
    func check(applicationPassword: String) -> Bool {
        guard let salt = authenticationSalt() else {return false}
        guard let encryptedPassword = self.applicationPassword() else {return false}
        
        let saltData = NSData.fromHexString(salt)
        let passwordData: NSData? = try! HashManager.generateAesKeyForString(applicationPassword, salt: saltData, roundCount: 2000)!
        
        return passwordData?.toHexString() == encryptedPassword
    }
    
    func set(applicationPassword: String) {
        let salt = authenticationSalt()
        
        let saltData = salt.flatMap{NSData(bytes: $0.asByteArray(), length: $0.asByteArray().count)} ?? NSData().generateRandomIV(32) as NSData
        let passwordHash = try! HashManager.generateAesKeyForString(applicationPassword, salt: saltData, roundCount: 2000)!
        
        setAuthenticationSalt(saltData.hexadecimalString())
        setApplicationPassword(passwordHash.hexadecimalString())
    }
    
}
