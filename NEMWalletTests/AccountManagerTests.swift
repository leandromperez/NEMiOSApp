//
//  AccountManagerTests.swift
//  NEMWalletTests
//
//  Created by Leandro Perez on 06/12/2020.
//  Copyright © 2020 NEM. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import NEMWallet

final class AccountManagerTests : QuickSpec {
    override func spec() {
        
        describe("account manager") {
            it("decrypts correctly") {
                
                let decrypted = AccountManager.sharedInstance.decryptPrivateKey(encryptedPrivateKey: TestConstants.encriptedPrivateKey, applicationPassword: {TestConstants.applicationPassword})
                expect(decrypted).to(equal(TestConstants.privateKey))
            }
        }
    }
}
