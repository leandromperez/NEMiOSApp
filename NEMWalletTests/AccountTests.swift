//
//  AccountTests.swift
//
//  This file is covered by the LICENSE file in the root of this project.
//  Copyright (c) 2017 NEM
//

import Quick
import Nimble
@testable import NEMWallet

final class AccountTests: QuickSpec {
    override func spec() {
        
        describe("account creation") {
            
            context("when generating a new account") {
                
                var accounts: [Account]!
                var generatedAccount: Account!
                var generatedAccountIndex: Array<Any>.Index!
                
                beforeSuite {
                    waitUntil { done in
                        AccountManager.sharedInstance.create(account: "Newly generated account", completion: { (result, createdAccount) in
                            
                            accounts = AccountManager.sharedInstance.accounts()
                            generatedAccount = createdAccount!
                            generatedAccountIndex = accounts.index(of: createdAccount!)!
                            
                            done()
                        })
                    }
                }
                
                it("saves the new account") {
                    expect(accounts).to(contain(generatedAccount))
                }
                
                it("sets the right title") {
                    expect(accounts[generatedAccountIndex].title).to(equal("Newly generated account"))
                }
                
                it("generates a valid account address") {
                    
                    let networkPrefix = Constants.activeNetwork == Constants.testNetwork ? "T" : "N"
                    expect(accounts[generatedAccountIndex].address).to(beginWith(networkPrefix))
                    expect(accounts[generatedAccountIndex].address.characters.count).to(equal(40))
                }
                
                it("generates a valid public and private key") {
                    /// A valid public key implies that the private key is also valid.
                    expect(AccountManager.sharedInstance.validateKey(accounts[generatedAccountIndex].publicKey)).to(beTruthy())
                }
                
                it("positions the account correctly") {
                    
                    let maxPosition = accounts.max { a, b in Int(a.position) < Int(b.position) }
                    expect(accounts[generatedAccountIndex].position).to(equal(maxPosition!.position))
                }
            }
            
            context("when importing an existing account") {
                
                var accounts: [Account]!
                var importedAccount: Account!
                var importedAccountIndex: Array<Any>.Index!
                
                beforeSuite {
                    waitUntil { done in
                        AccountManager.sharedInstance.create(account: "Newly imported account", withPrivateKey: "4846c7752fe1f4ce151224d2ca9b9d38411631cea1a3a87169b35e9058bc729a", completion: { (result, createdAccount) in
                            
                            accounts = AccountManager.sharedInstance.accounts()
                            importedAccount = createdAccount!
                            importedAccountIndex = accounts.index(of: createdAccount!)!
                            
                            done()
                        })
                    }
                }
                
                it("saves the existing account") {
                    expect(accounts).to(contain(importedAccount))
                }
                
                it("sets the right title") {
                    expect(accounts[importedAccountIndex].title).to(equal("Newly imported account"))
                }
                
                it("generates the valid account address") {
                    
                    let accountAddress = Constants.activeNetwork == Constants.testNetwork ? "TB2DA2KFAM4GE2JU4XIPRGO72KBRMJUYS7CUXGLD" : "NB2DA2KFAM4GE2JU4XIPRGO72KBRMJUYS7LHNEUB"
                    expect(accounts[importedAccountIndex].address).to(equal(accountAddress))
                }
                
                it("generates the valid public key") {
                    expect(accounts[importedAccountIndex].publicKey).to(equal("4e312ef765e2916e4012a5290ae24b3806bdcbffda9560250749789c7bd35b50"))
                }
                
                it("positions the account correctly") {
                    
                    let maxPosition = accounts.max { a, b in Int(a.position) < Int(b.position) }
                    expect(accounts[importedAccountIndex].position).to(equal(maxPosition!.position))
                }
            }
        }
        
        describe("account deletion") {
            
            var accounts: [Account]!
            var deletedAccount: Account!
            
            beforeSuite {
                
                accounts = AccountManager.sharedInstance.accounts()
                deletedAccount = accounts[Int(arc4random_uniform(UInt32(accounts.count)) + UInt32(0))]
                
                waitUntil { done in
                    AccountManager.sharedInstance.delete(account: deletedAccount, completion: { (result) in
                        accounts = AccountManager.sharedInstance.accounts()
                        done()
                    })
                }
            }
            
            it("deletes the account from the device") {
                expect(accounts).notTo(contain(deletedAccount))
            }
            
            it("updates the position of all remaining accounts") {
                
                let maxPosition = accounts.max { a, b in Int(a.position) < Int(b.position) }
                var positionIncrement = 0
                
                for account in accounts {
                    if Int(account.position) == positionIncrement && positionIncrement < (accounts.count - 1)  {
                        positionIncrement += 1
                    }
                }
                
                expect(positionIncrement).to(equal(Int(maxPosition!.position)))
            }
        }
        
        describe("account position move") {
            
            it("saves the position move") {
                
                var accounts: [Account]!
                accounts = AccountManager.sharedInstance.accounts()
                
                var movedAccounts = accounts!
                let movedAccount = movedAccounts[Int(arc4random_uniform(UInt32(movedAccounts.count)) + UInt32(0))]
                let movedAccountIndexBefore = movedAccounts.index(of: movedAccount)!
                let movedAccountIndexAfter = Int(arc4random_uniform(UInt32(accounts.count)) + UInt32(0))
                
                movedAccounts.remove(at: movedAccountIndexBefore)
                movedAccounts.insert(movedAccount, at: movedAccountIndexAfter)
                
                waitUntil { done in
                    
                    AccountManager.sharedInstance.updatePosition(ofAccounts: movedAccounts, completion: { (result) in
                        accounts = AccountManager.sharedInstance.accounts()
                        done()
                    })
                }
                
                expect(accounts.index(of: movedAccount)).to(equal(movedAccountIndexAfter))
            }
        }
    }
}




struct TestConstants {
    static let privateKey = "3f996eafce31549cb6271b5c5b9626e26322ebd0225b559bfd135f9fbaf6bf3a"
    static let publicKey = "802d0efbb574857eb444c60b3728d8acb13cd163aa672e33871c963583fa7f0b"
    static let encriptedPrivateKey = "86234100b8bc3c337779380a2c80287a7b439170b179c8097f3e1532bd9659dc34f6c2bf5439bfce43d4216580cf9f67a498b917b684842d11aa22abe2f4d85f"
    static let inBuffer: [UInt8] =  [ 128, 45, 14, 251, 181, 116, 133, 126, 180, 68, 198, 11, 55, 40, 216, 172, 177, 60, 209, 99, 170, 103, 46, 51, 135, 28, 150, 53, 131, 250, 127, 11]
    static let stepOneSHA256: [UInt8] = [ 50, 97, 53, 102, 48, 57, 56, 55, 54, 51, 53, 57, 49, 56, 101, 51, 102, 101, 56, 49, 56, 49, 101, 49, 50, 101, 54, 56, 99, 98, 50, 50, 57, 98, 99, 49, 48, 48, 98, 100, 55, 54, 97, 50, 51, 56, 48, 56, 50, 100, 97, 51, 55, 97, 98, 50, 97, 54, 52, 52, 100, 102, 54, 102]
    static let stepOneSHA256Text = "2a5f0987635918e3fe8181e12e68cb229bc100bd76a238082da37ab2a644df6f"
    static let stepTwoRIPEMD160Text = "1f727519bddc808e09cfe9bd35ea871fde25e855"
    static let stepTwoRIPEMD160Buffer : [UInt8] = [ 31, 114, 117, 25, 189, 220, 128, 142, 9, 207, 233, 189, 53, 234, 135, 31, 222, 37, 232, 85]
    static let version: [UInt8] = [ 104]
    static let stepThreeVersionPrefixedRipemd160Buffer: [UInt8] = [ 104, 31, 114, 117, 25, 189, 220, 128, 142, 9, 207, 233, 189, 53, 234, 135, 31, 222, 37, 232, 85]
    static let checksumHash: [UInt8] = [ 101, 56, 102, 100, 57, 102, 98, 56, 49, 57, 55, 51, 50, 51, 48, 52, 55, 97, 50, 100, 98, 56, 51, 54, 56, 102, 56, 51, 100, 101, 101, 53, 98, 102, 99, 52, 50, 53, 97, 50, 50, 54, 100, 49, 53, 48, 101, 99, 53, 98, 53, 101, 100, 99, 56, 48, 49, 52, 101, 98, 52, 99, 51, 101]
    static let checksumText = "e8fd9fb8197323047a2db8368f83dee5bfc425a226d150ec5b5edc8014eb4c3e"
    static let checksumBuffer: [UInt8] = [232, 253, 159, 184, 25, 115, 35, 4, 122, 45, 184, 54, 143, 131, 222, 229, 191, 196, 37, 162, 38, 209, 80, 236, 91, 94, 220, 128, 20, 235, 76, 62]
    static let checksumStep1: [UInt8] = [ 232]
    static let checksumStep2: [UInt8] = [ 232, 253]
    static let checksumStep3: [UInt8] = [ 232, 253, 159]
    static let checksumStep4: [UInt8] = [ 232, 253, 159, 184]
    static let stepFourResultBuffer: [UInt8] = [ 104, 31, 114, 117, 25, 189, 220, 128, 142, 9, 207, 233, 189, 53, 234, 135, 31, 222, 37, 232, 85, 232, 253, 159, 184]
    static let address = "NAPXE5IZXXOIBDQJZ7U32NPKQ4P54JPIKXUP3H5Y"
}

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


final class AccountManagerTests : QuickSpec {
    override func spec() {
        
        describe("account manager") {
            it("decrypts correctly") {
                let decrypted = AccountManager.sharedInstance.decryptPrivateKey(encryptedPrivateKey: TestConstants.encriptedPrivateKey)
                expect(decrypted).to(equal(TestConstants.privateKey))
            }
        }
    }
}



final class AddressGenerationTests : QuickSpec {
    
    override func spec() {
        describe("1 inBuffer = publicKey.asByteArray()") {
            it("must be ok") {
                expect(TestConstants.publicKey.asByteArray()).to(equal(TestConstants.inBuffer))
            }
        }
        
        describe("2 SHA256_hash") {
            it("must be correct for public key") {
                var inBuffer = TestConstants.publicKey.asByteArray()
                var stepOneSHA256: Array<UInt8> = Array(repeating: 0, count: 64)
                SHA256_hash(&stepOneSHA256, &inBuffer, 32)
                expect(stepOneSHA256).to(equal(TestConstants.stepOneSHA256))
            }
        }
        
        describe("3 stepOneSHA256Text") {
            it("must be correct for public key") {
                var inBuffer = TestConstants.publicKey.asByteArray()
                var stepOneSHA256: Array<UInt8> = Array(repeating: 0, count: 64)
                SHA256_hash(&stepOneSHA256, &inBuffer, 32)
                
                let stepOneSHA256Text = String(bytes: stepOneSHA256, encoding: .utf8)!
                
                
                expect(stepOneSHA256Text).to(equal(TestConstants.stepOneSHA256Text))
            }
        }
        
        describe("4 stepTwoRIPEMD160Text") {
            it("must be correct") {
                var inBuffer = TestConstants.publicKey.asByteArray()
                var stepOneSHA256: Array<UInt8> = Array(repeating: 0, count: 64)
                SHA256_hash(&stepOneSHA256, &inBuffer, 32)
                
                let stepOneSHA256Text = String(bytes: stepOneSHA256, encoding: .utf8)!
                
                let stepTwoRIPEMD160Text = RIPEMD.hexStringDigest(stepOneSHA256Text) as String
                print("4 🧔🏻 stepTwoRIPEMD160Text: \(stepTwoRIPEMD160Text)")
                expect(stepTwoRIPEMD160Text).to(equal(TestConstants.stepTwoRIPEMD160Text))
            }
        }
        describe("5 stepTwoRIPEMD160Buffer") {
            it("must be correct") {
                var inBuffer = TestConstants.publicKey.asByteArray()
                var stepOneSHA256: Array<UInt8> = Array(repeating: 0, count: 64)
                SHA256_hash(&stepOneSHA256, &inBuffer, 32)
                
                let stepOneSHA256Text = String(bytes: stepOneSHA256, encoding: .utf8)!
                
                let stepTwoRIPEMD160Text = RIPEMD.hexStringDigest(stepOneSHA256Text) as String
                
                let stepTwoRIPEMD160Buffer = stepTwoRIPEMD160Text.asByteArray()
                print("5 🧔🏻 stepTwoRIPEMD160Buffer: \(stepTwoRIPEMD160Buffer.stringify)")
                
                expect(stepTwoRIPEMD160Buffer).to(equal(TestConstants.stepTwoRIPEMD160Buffer))

            }
        }
        
        describe("6 version") {
            it("must be correct") {
                var inBuffer = TestConstants.publicKey.asByteArray()
                var stepOneSHA256: Array<UInt8> = Array(repeating: 0, count: 64)
                SHA256_hash(&stepOneSHA256, &inBuffer, 32)
                
                let stepOneSHA256Text = String(bytes: stepOneSHA256, encoding: .utf8)!
                
                let stepTwoRIPEMD160Text = RIPEMD.hexStringDigest(stepOneSHA256Text) as String
                
                let stepTwoRIPEMD160Buffer = stepTwoRIPEMD160Text.asByteArray()
                print("5 🧔🏻 stepTwoRIPEMD160Buffer: \(stepTwoRIPEMD160Buffer.stringify)")
                
                
                var version = Array<UInt8>()
                version.append(Constants.activeNetwork)
                print("6 🧔🏻 version: \(version.stringify)")
                
                expect(version).to(equal(TestConstants.version))
            }
        }
        
        describe("7 stepThreeVersionPrefixedRipemd160Buffer") {
            it("must be correct") {
                var inBuffer = TestConstants.publicKey.asByteArray()
                var stepOneSHA256: Array<UInt8> = Array(repeating: 0, count: 64)
                SHA256_hash(&stepOneSHA256, &inBuffer, 32)
                
                let stepOneSHA256Text = String(bytes: stepOneSHA256, encoding: .utf8)!
                
                let stepTwoRIPEMD160Text = RIPEMD.hexStringDigest(stepOneSHA256Text) as String
                
                let stepTwoRIPEMD160Buffer = stepTwoRIPEMD160Text.asByteArray()
                print("5 🧔🏻 stepTwoRIPEMD160Buffer: \(stepTwoRIPEMD160Buffer.stringify)")
                
                
                var version = Array<UInt8>()
                version.append(Constants.activeNetwork)
                print("6 🧔🏻 version: \(version.stringify)")
                
                var stepThreeVersionPrefixedRipemd160Buffer = version + stepTwoRIPEMD160Buffer
                print("7 🧔🏻 stepThreeVersionPrefixedRipemd160Buffer: \(stepThreeVersionPrefixedRipemd160Buffer.stringify)")
                
                expect(stepThreeVersionPrefixedRipemd160Buffer).to(equal(TestConstants.stepThreeVersionPrefixedRipemd160Buffer))
            }
        }
        
        describe("8, 9, 10 checksumHash and stepThreeVersionPrefixedRipemd160Buffer") {
            it("must be correct") {
                var inBuffer = TestConstants.publicKey.asByteArray()
                var stepOneSHA256: Array<UInt8> = Array(repeating: 0, count: 64)
                SHA256_hash(&stepOneSHA256, &inBuffer, 32)
                
                let stepOneSHA256Text = String(bytes: stepOneSHA256, encoding: .utf8)!
                
                let stepTwoRIPEMD160Text = RIPEMD.hexStringDigest(stepOneSHA256Text) as String
                
                let stepTwoRIPEMD160Buffer = stepTwoRIPEMD160Text.asByteArray()
                print("5 🧔🏻 stepTwoRIPEMD160Buffer: \(stepTwoRIPEMD160Buffer.stringify)")
                
                
                var version = Array<UInt8>()
                version.append(Constants.activeNetwork)
                print("6 🧔🏻 version: \(version.stringify)")
                
                var stepThreeVersionPrefixedRipemd160Buffer = version + stepTwoRIPEMD160Buffer
                print("7 🧔🏻 stepThreeVersionPrefixedRipemd160Buffer: \(stepThreeVersionPrefixedRipemd160Buffer.stringify)")
                
                var checksumHash: Array<UInt8> = Array(repeating: 0, count: 64)
                print("8 🧔🏻 checksumHash: \(checksumHash.stringify)")
                
                SHA256_hash(&checksumHash, &stepThreeVersionPrefixedRipemd160Buffer, 21)
                print("9 🧔🏻 checksumHash: \(checksumHash.stringify))")
                print("10 🧔🏻 stepThreeVersionPrefixedRipemd160Buffer: \(stepThreeVersionPrefixedRipemd160Buffer.stringify)")
                
                expect(checksumHash).to(equal(TestConstants.checksumHash))
                expect(stepThreeVersionPrefixedRipemd160Buffer).to(equal(TestConstants.stepThreeVersionPrefixedRipemd160Buffer))
            }
        }
        
        describe("11 checksumHash and stepThreeVersionPrefixedRipemd160Buffer") {
            it("must be correct") {
                var inBuffer = TestConstants.publicKey.asByteArray()
                var stepOneSHA256: Array<UInt8> = Array(repeating: 0, count: 64)
                SHA256_hash(&stepOneSHA256, &inBuffer, 32)
                
                let stepOneSHA256Text = String(bytes: stepOneSHA256, encoding: .utf8)!
                
                let stepTwoRIPEMD160Text = RIPEMD.hexStringDigest(stepOneSHA256Text) as String
                
                let stepTwoRIPEMD160Buffer = stepTwoRIPEMD160Text.asByteArray()
                print("5 🧔🏻 stepTwoRIPEMD160Buffer: \(stepTwoRIPEMD160Buffer.stringify)")
                
                
                var version = Array<UInt8>()
                version.append(Constants.activeNetwork)
                print("6 🧔🏻 version: \(version.stringify)")
                
                var stepThreeVersionPrefixedRipemd160Buffer = version + stepTwoRIPEMD160Buffer
                print("7 🧔🏻 stepThreeVersionPrefixedRipemd160Buffer: \(stepThreeVersionPrefixedRipemd160Buffer.stringify)")
                
                var checksumHash: Array<UInt8> = Array(repeating: 0, count: 64)
                print("8 🧔🏻 checksumHash: \(checksumHash.stringify)")
                
                SHA256_hash(&checksumHash, &stepThreeVersionPrefixedRipemd160Buffer, 21)
                print("9 🧔🏻 checksumHash: \(checksumHash.stringify))")
                print("10 🧔🏻 stepThreeVersionPrefixedRipemd160Buffer: \(stepThreeVersionPrefixedRipemd160Buffer.stringify)")
               
                expect(checksumHash).to(equal(TestConstants.checksumHash))
                expect(stepThreeVersionPrefixedRipemd160Buffer).to(equal(TestConstants.stepThreeVersionPrefixedRipemd160Buffer))
            }
        }
        describe("11-16 checksum") {
            it("must be correct") {
                var inBuffer = TestConstants.publicKey.asByteArray()
                var stepOneSHA256: Array<UInt8> = Array(repeating: 0, count: 64)
                SHA256_hash(&stepOneSHA256, &inBuffer, 32)
                
                let stepOneSHA256Text = String(bytes: stepOneSHA256, encoding: .utf8)!
                
                let stepTwoRIPEMD160Text = RIPEMD.hexStringDigest(stepOneSHA256Text) as String
                
                let stepTwoRIPEMD160Buffer = stepTwoRIPEMD160Text.asByteArray()
                print("5 🧔🏻 stepTwoRIPEMD160Buffer: \(stepTwoRIPEMD160Buffer.stringify)")
                
                
                var version = Array<UInt8>()
                version.append(Constants.activeNetwork)
                print("6 🧔🏻 version: \(version.stringify)")
                
                var stepThreeVersionPrefixedRipemd160Buffer = version + stepTwoRIPEMD160Buffer
                print("7 🧔🏻 stepThreeVersionPrefixedRipemd160Buffer: \(stepThreeVersionPrefixedRipemd160Buffer.stringify)")
                
                var checksumHash: Array<UInt8> = Array(repeating: 0, count: 64)
                print("8 🧔🏻 checksumHash: \(checksumHash.stringify)")
                
                SHA256_hash(&checksumHash, &stepThreeVersionPrefixedRipemd160Buffer, 21)
                print("9 🧔🏻 checksumHash: \(checksumHash.stringify))")
                print("10 🧔🏻 stepThreeVersionPrefixedRipemd160Buffer: \(stepThreeVersionPrefixedRipemd160Buffer.stringify)")
                
                let checksumText = NSString(bytes: checksumHash, length: checksumHash.count, encoding: String.Encoding.utf8.rawValue) as! String
                print("11 🧔🏻 checksumText: \(checksumText)")
                expect(checksumText).to(equal(TestConstants.checksumText))

                var checksumBuffer = checksumText.asByteArray()
                print("12 🧔🏻 checksumBuffer: \(checksumBuffer.reduce("", { $0 + ", \($1)" }))")
                expect(checksumBuffer).to(equal(TestConstants.checksumBuffer))
                
                var checksum = Array<UInt8>()
                checksum.append(checksumBuffer[0])
                print("13 🧔🏻 checksum: \(checksum.stringify)")
                expect(checksum).to(equal(TestConstants.checksumStep1))
                
                checksum.append(checksumBuffer[1])
                print("14 🧔🏻 checksum: \(checksum.stringify)")
                expect(checksum).to(equal(TestConstants.checksumStep2))
                
                checksum.append(checksumBuffer[2])
                print("15 🧔🏻 checksum: \(checksum.stringify)")
                expect(checksum).to(equal(TestConstants.checksumStep3))
                
                checksum.append(checksumBuffer[3])
                print("16 🧔🏻 checksum: \(checksum.stringify)")
                expect(checksum).to(equal(TestConstants.checksumStep4))
            }
        }
        
        describe("17 stepFourResultBuffer") {
            it("must be correct") {
                var inBuffer = TestConstants.publicKey.asByteArray()
                var stepOneSHA256: Array<UInt8> = Array(repeating: 0, count: 64)
                SHA256_hash(&stepOneSHA256, &inBuffer, 32)
                
                let stepOneSHA256Text = String(bytes: stepOneSHA256, encoding: .utf8)!
                
                let stepTwoRIPEMD160Text = RIPEMD.hexStringDigest(stepOneSHA256Text) as String
                
                let stepTwoRIPEMD160Buffer = stepTwoRIPEMD160Text.asByteArray()
                print("5 🧔🏻 stepTwoRIPEMD160Buffer: \(stepTwoRIPEMD160Buffer.stringify)")
                
                
                var version = Array<UInt8>()
                version.append(Constants.activeNetwork)
                print("6 🧔🏻 version: \(version.stringify)")
                
                var stepThreeVersionPrefixedRipemd160Buffer = version + stepTwoRIPEMD160Buffer
                print("7 🧔🏻 stepThreeVersionPrefixedRipemd160Buffer: \(stepThreeVersionPrefixedRipemd160Buffer.stringify)")
                
                var checksumHash: Array<UInt8> = Array(repeating: 0, count: 64)
                print("8 🧔🏻 checksumHash: \(checksumHash.stringify)")
                
                SHA256_hash(&checksumHash, &stepThreeVersionPrefixedRipemd160Buffer, 21)
                print("9 🧔🏻 checksumHash: \(checksumHash.stringify))")
                print("10 🧔🏻 stepThreeVersionPrefixedRipemd160Buffer: \(stepThreeVersionPrefixedRipemd160Buffer.stringify)")
                
                let checksumText = NSString(bytes: checksumHash, length: checksumHash.count, encoding: String.Encoding.utf8.rawValue) as! String
                print("11 🧔🏻 checksumText: \(checksumText)")
                
                var checksumBuffer = checksumText.asByteArray()
                print("12 🧔🏻 checksumBuffer: \(checksumBuffer.reduce("", { $0 + ", \($1)" }))")
                
                var checksum = Array<UInt8>()
                checksum.append(checksumBuffer[0])
                print("13 🧔🏻 checksum: \(checksum.stringify)")
                
                checksum.append(checksumBuffer[1])
                print("14 🧔🏻 checksum: \(checksum.stringify)")
                
                checksum.append(checksumBuffer[2])
                print("15 🧔🏻 checksum: \(checksum.stringify)")
                
                checksum.append(checksumBuffer[3])
                print("16 🧔🏻 checksum: \(checksum.stringify)")
                
                let stepFourResultBuffer = stepThreeVersionPrefixedRipemd160Buffer + checksum
                print("17 🧔🏻 stepFourResultBuffer: \(stepFourResultBuffer.stringify)")
                
                expect(stepFourResultBuffer).to(equal(TestConstants.stepFourResultBuffer))
            }
        }
        
        describe("18 address") {
            it("must be correct") {
                var inBuffer = TestConstants.publicKey.asByteArray()
                var stepOneSHA256: Array<UInt8> = Array(repeating: 0, count: 64)
                SHA256_hash(&stepOneSHA256, &inBuffer, 32)
                
                let stepOneSHA256Text = String(bytes: stepOneSHA256, encoding: .utf8)!
                
                let stepTwoRIPEMD160Text = RIPEMD.hexStringDigest(stepOneSHA256Text) as String
                
                let stepTwoRIPEMD160Buffer = stepTwoRIPEMD160Text.asByteArray()
                print("5 🧔🏻 stepTwoRIPEMD160Buffer: \(stepTwoRIPEMD160Buffer.stringify)")
                
                
                var version = Array<UInt8>()
                version.append(Constants.activeNetwork)
                print("6 🧔🏻 version: \(version.stringify)")
                
                var stepThreeVersionPrefixedRipemd160Buffer = version + stepTwoRIPEMD160Buffer
                print("7 🧔🏻 stepThreeVersionPrefixedRipemd160Buffer: \(stepThreeVersionPrefixedRipemd160Buffer.stringify)")
                
                var checksumHash: Array<UInt8> = Array(repeating: 0, count: 64)
                print("8 🧔🏻 checksumHash: \(checksumHash.stringify)")
                
                SHA256_hash(&checksumHash, &stepThreeVersionPrefixedRipemd160Buffer, 21)
                print("9 🧔🏻 checksumHash: \(checksumHash.stringify))")
                print("10 🧔🏻 stepThreeVersionPrefixedRipemd160Buffer: \(stepThreeVersionPrefixedRipemd160Buffer.stringify)")
                
                let checksumText = NSString(bytes: checksumHash, length: checksumHash.count, encoding: String.Encoding.utf8.rawValue) as! String
                print("11 🧔🏻 checksumText: \(checksumText)")
                
                var checksumBuffer = checksumText.asByteArray()
                print("12 🧔🏻 checksumBuffer: \(checksumBuffer.reduce("", { $0 + ", \($1)" }))")
                
                var checksum = Array<UInt8>()
                checksum.append(checksumBuffer[0])
                print("13 🧔🏻 checksum: \(checksum.stringify)")
                
                checksum.append(checksumBuffer[1])
                print("14 🧔🏻 checksum: \(checksum.stringify)")
                
                checksum.append(checksumBuffer[2])
                print("15 🧔🏻 checksum: \(checksum.stringify)")
                
                checksum.append(checksumBuffer[3])
                print("16 🧔🏻 checksum: \(checksum.stringify)")
                
                let stepFourResultBuffer = stepThreeVersionPrefixedRipemd160Buffer + checksum
                print("17 🧔🏻 stepFourResultBuffer: \(stepFourResultBuffer.stringify)")
                
                let address = Base32Encode(Data(bytes: stepFourResultBuffer, count: stepFourResultBuffer.count))
                print("18 🧔🏻 address: \(address)")
                expect(address).to(equal(TestConstants.address))
            }
        }
        
        
    }
}

struct KeyGenerator {
    /// Generates a new and unique private key.
    func generatePrivateKey() -> String {
        
        var privateKeyBytes: Array<UInt8> = Array(repeating: 0, count: 32)
        createPrivateKey(&privateKeyBytes)
        
        let privateKey = Data(privateKeyBytes).toHexadecimalString()
        
        return privateKey.nemKeyNormalized()!
    }
    
    /**
     Generates the public key from the provided private key.
     
     - Parameter privateKey: The private key for which the public key should get generated.
     
     - Returns: The generated public key as a hex string.
     */
    func generatePublicKey(fromPrivateKey privateKey: String) -> String {
        
        var publicKeyBytes: Array<UInt8> = Array(repeating: 0, count: 32)
        var privateKeyBytes: Array<UInt8> = privateKey.asByteArrayEndian(privateKey.asByteArray().count)
        createPublicKey(&publicKeyBytes, &privateKeyBytes)
        
        let publicKey = Data(publicKeyBytes).toHexadecimalString()
        
        return publicKey.nemKeyNormalized()!
    }
}


struct PasswordContants {
    static let correctPassword = "123123"
    static let encryptedPassword = "9b316300436d1dd4f7d5575a5f6227a67ef0491f2e523a0385f508a20438e6e9"
    static let salt = "2399ff99c31a18a519c8e477c3ab9e8e1e97af883bab0367e9c6a226149eb0f9"
    static let passwordData : [UInt8] = [12, 250, 38, 100, 127, 37, 82, 206, 190, 142, 185, 179, 64, 228, 120, 157, 195, 17, 134, 25, 42, 89, 164, 85, 99, 10, 120, 107, 115, 149, 186, 129]
    static let saltData : [UInt8] = [35, 153, 255, 153, 195, 26, 24, 165, 25, 200, 228, 119, 195, 171, 158, 142, 30, 151, 175, 136, 59, 171, 3, 103, 233, 198, 162, 38, 20, 158, 176, 249]
}

final class PasswordManagerTests : QuickSpec {
    
    
    override func spec() {
        var setSalt : String?
        var setPass : String?
        
        let manager = PasswordManager(applicationPassword: { return PasswordContants.encryptedPassword },
                                      authorizationSalt: { return PasswordContants.salt },
                                      setApplicationPassword: {setPass = $0 },
                                      setAuthenticationSalt: {setSalt = $0})
        
        describe("password manager"){
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


final class DataTests : QuickSpec{
    override func spec() {

        describe("from byte array") {
            it("must create a proper Data object") {
                let saltData = NSData.fromHexString(PasswordContants.salt)
                let bytes = saltData.arrayOfBytes()
                let generated = NSData(bytes: bytes, length: bytes.count)
                expect(saltData).to(equal(generated))

            }
        }
        
        describe("fromHexString to array of bytes") {
            it("must be correct") {
                let saltData = NSData.fromHexString(PasswordContants.salt)
                let bytes = saltData.arrayOfBytes()
                expect(bytes).to(equal(PasswordContants.saltData))
            }
        }
    }
}
