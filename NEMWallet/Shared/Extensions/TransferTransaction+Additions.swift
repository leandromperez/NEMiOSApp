//
//  TransferTransaction+Additions.swift
//
//  This file is covered by the LICENSE file in the root of this project.
//  Copyright (c) 2016 NEM
//

import Foundation

// MARK: - Model Equatable Extension

extension TransferTransaction: Equatable { }

public func == (lhs: TransferTransaction, rhs: TransferTransaction) -> Bool {
    return lhs.type == rhs.type &&
    lhs.timeStamp == rhs.timeStamp &&
    lhs.metaData == rhs.metaData &&
    lhs.amount == rhs.amount &&
    lhs.fee == rhs.fee &&
    lhs.transferType == rhs.transferType &&
    lhs.recipient == rhs.recipient &&
    lhs.message == rhs.message &&
    lhs.deadline == rhs.deadline &&
    lhs.signature == rhs.signature &&
    lhs.signer == rhs.signer
}

// MARK: - Model Custom String Convertible Extension

extension TransferTransaction: CustomStringConvertible {
    
    public var description: String {
        return "NemIOSClient.TransferTransaction(type: \(type), timeStamp: \(timeStamp.unwrappedString), metaData: \(metaData.unwrappedString), amount: \(amount.unwrappedString), fee: \(fee.unwrappedString), transferType: \(transferType.unwrappedString), recipient: \(recipient.unwrappedString), message: \(String(describing: message)), deadline: \(deadline.unwrappedString), signature: \(signature.unwrappedString), signer: \(signer.unwrappedString))"
    }
}


extension Optional {
    var unwrappedString : String {
        switch self {
        case .none :
            return "nil"
        case .some(let value):
            return "\(value)"
        }
    }
}
