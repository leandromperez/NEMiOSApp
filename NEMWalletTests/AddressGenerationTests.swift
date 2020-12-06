//
//  AddressGenerationTests.swift
//  NEMWalletTests
//
//  Created by Leandro Perez on 06/12/2020.
//  Copyright © 2020 NEM. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import NEMWallet

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

extension Array {
    var stringify : String {
        return "[" + reduce("", { $0 + ", \($1)" }).dropFirst(2) + "]"
    }
}
