//
//  MultisigAggregateModificationTransaction+Additions.swift
//
//  This file is covered by the LICENSE file in the root of this project.
//  Copyright (c) 2016 NEM
//

import Foundation

// MARK: - Model Custom String Convertible Extension

extension MultisigAggregateModificationTransaction: CustomStringConvertible {
    
    public var description: String {
        return "NemIOSClient.MultisigAggregateModificationTransaction(type: \(type), metaData: \(metaData.unwrappedString), version: \(version.unwrappedString), timeStamp: \(timeStamp.unwrappedString), fee: \(fee.unwrappedString), modifications: \(modifications), relativeChange: \(relativeChange.unwrappedString), deadline: \(deadline.unwrappedString), signature: \(signature.unwrappedString), signer: \(signer.unwrappedString))"
    }
}
