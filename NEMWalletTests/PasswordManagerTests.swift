//
//  PasswordManagerTests.swift
//  NEMWalletTests
//
//  Created by Leandro Perez on 06/12/2020.
//  Copyright © 2020 NEM. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import NEMWallet

struct PasswordContants {
    static let correctPassword = "123123"
    static let encryptedPassword = "9b316300436d1dd4f7d5575a5f6227a67ef0491f2e523a0385f508a20438e6e9"
    static let salt = "2399ff99c31a18a519c8e477c3ab9e8e1e97af883bab0367e9c6a226149eb0f9"
    static let passwordData : [UInt8] = [12, 250, 38, 100, 127, 37, 82, 206, 190, 142, 185, 179, 64, 228, 120, 157, 195, 17, 134, 25, 42, 89, 164, 85, 99, 10, 120, 107, 115, 149, 186, 129]
    static let saltData : [UInt8] = [35, 153, 255, 153, 195, 26, 24, 165, 25, 200, 228, 119, 195, 171, 158, 142, 30, 151, 175, 136, 59, 171, 3, 103, 233, 198, 162, 38, 20, 158, 176, 249]
}

final class PasswordManagerTests : QuickSpec {
    
    
    override func spec() {
    
        describe("password manager"){
            let manager = PasswordManager(applicationPassword: { return PasswordContants.encryptedPassword },
                                          authorizationSalt: { return PasswordContants.salt },
                                          setApplicationPassword: { _ in },
                                          setAuthenticationSalt: { _ in })
            
            describe("check application password") {
                context("incorrect password") {
                    it("returns false ") {
                        let incorrect = manager.check(applicationPassword: "incorrect")
                        expect(incorrect).to(beFalse())
                    }
                }
                context("correct password") {
                    it("returns true") {
                        let correct = manager.check(applicationPassword: PasswordContants.correctPassword)
                        expect(correct).to(beTrue())
                    }
                }
            }
            
            describe("set application password"){
                
                it("saves an encrypted password") {
                    
                    var applicationPassword : String? = nil
                    var salt = ""
                    
                    let manager = PasswordManager(applicationPassword: { return applicationPassword},
                                                  authorizationSalt: { return salt },
                                                  setApplicationPassword: {applicationPassword = $0 },
                                                  setAuthenticationSalt: {salt = $0})
                    
                    let chosenPassword = "123123123"
                    manager.set(applicationPassword: chosenPassword)
                    
                    //Since it is encrypted, it must be different than the chosenPassword
                    expect(applicationPassword).toNot(equal(chosenPassword))
                }
                
                
                it("saves an encrypted salt") {
                    
                    var applicationPassword : String? = nil
                    var savedSalt : String? = nil
                    
                    let manager = PasswordManager(applicationPassword: { return applicationPassword},
                                                  authorizationSalt: { return savedSalt },
                                                  setApplicationPassword: {applicationPassword = $0 },
                                                  setAuthenticationSalt: {savedSalt = $0})
                    
                    let chosenPassword = "123123123"
                    manager.set(applicationPassword: chosenPassword)
                    
                    expect(savedSalt).toNot(beNil())
                }
                
                it("saves a password that later is correctly decripted") {
                    
                    var pass = ""
                    var salt = ""
                    
                    let manager = PasswordManager(applicationPassword: { return pass},
                                                  authorizationSalt: { return salt },
                                                  setApplicationPassword: {pass = $0 },
                                                  setAuthenticationSalt: {salt = $0})
                    
                    let correct = "123123123"
                    manager.set(applicationPassword: correct)
                    
                    expect(manager.check(applicationPassword: "123")).to(beFalse())
                    expect(manager.check(applicationPassword: correct)).to(beTrue())
                }
            }
        }
    }
}
