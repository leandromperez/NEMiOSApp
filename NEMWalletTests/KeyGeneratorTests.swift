//
//  KeyGeneratorTests.swift
//  NEMWalletTests
//
//  Created by Leandro Perez on 06/12/2020.
//  Copyright © 2020 NEM. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import NEMWallet

final class KeyGeneratorTests : QuickSpec {
    override func spec() {
        
        describe("generate private key") {
            it("creates a key") {
                let privateKey = KeyGenerator().generatePrivateKey()
                expect(privateKey.count).to(equal(TestConstants.privateKey.count))
            }
        }
        
        describe("generate public key") {
            it("creates a public key from the private key") {
                let publicKey = KeyGenerator().generatePublicKey(fromPrivateKey: TestConstants.privateKey)
                expect(publicKey).to(equal(TestConstants.publicKey))
            }
        }
    }
}

