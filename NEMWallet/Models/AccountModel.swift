//
//  AccountModel.swift
//
//  This file is covered by the LICENSE file in the root of this project.
//  Copyright (c) 2016 NEM
//

import Foundation
import CoreData

/// Represents an account object.
open class Account: NSManagedObject {
    
    // MARK: - Model Properties
    
    /// The title of the account.
    @NSManaged var title: String
    
    /// The address of the account.
    /// - Each account has a unique address. First letter of an address indicate the network the account belongs to. Currently two networks are defined: the test network whose account addresses start with a capital T and the main network whose account addresses always start with a capital N. Addresses have always a length of 40 characters and are base-32 encoded.
    @NSManaged var address: String
    
    /// The public key of the account.
    @NSManaged var publicKey: String
    
    /// The encrypted private key of the account.
    @NSManaged var privateKey: String
    
    /// The position of the account in the accounts list.
    @NSManaged var position: NSNumber
    
    /// The hash of the latest transaction for the account.
    @NSManaged var latestTransactionHash: String
}
