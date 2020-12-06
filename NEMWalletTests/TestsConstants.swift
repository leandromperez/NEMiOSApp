//
//  TestsConstants.swift
//  NEMWalletTests
//
//  Created by Leandro Perez on 06/12/2020.
//  Copyright © 2020 NEM. All rights reserved.
//

import Foundation

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
