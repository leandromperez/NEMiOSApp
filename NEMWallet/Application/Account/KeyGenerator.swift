//
//  KeyGenerator.swift
//  NEMWallet
//
//  Created by Leandro Perez on 05/12/2020.
//  Copyright © 2020 NEM. All rights reserved.
//

import Foundation

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
