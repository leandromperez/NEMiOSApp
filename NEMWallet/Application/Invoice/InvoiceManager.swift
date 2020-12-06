//
//  InvoiceManager.swift
//
//  This file is covered by the LICENSE file in the root of this project.
//  Copyright (c) 2016 NEM
//

import Foundation
import CoreStore
import Contacts

/**
    The account manager singleton used to perform all kinds of actions
    in relationship with an account. Use this managers available methods
    instead of writing your own logic.
 */
final class InvoiceManager {
    
    // MARK: - Manager Properties
    
    /// The singleton for the invoice manager.
    public static let sharedInstance = InvoiceManager()
    
    /// A contact that will get fetched from the address book add contact view controller when available.
    public var contactToCreate: CNMutableContact?

    // MARK: - Public Manager Methods

    /**
        Fetches all stored invoices from the database.
     
        - Returns: An array of invoices ordered by id (ascending).
     */
    public func invoices() -> [Invoice] {
        
        let invoices = try? DatabaseManager.sharedInstance.dataStack.fetchAll(From(Invoice.self), OrderBy<Invoice>(.ascending("id")))
         
        return invoices ?? []
    }
    
    /**
        Creates a new invoice object and stores that object in the database.
     
        - Parameter accountTitle: The title of the recipient account.
        - Parameter accountAddress: The address of the recipient account.
        - Parameter amount: The invoice amount.
        - Parameter message: The invoice message.
     
        - Returns: The result of the operation - success or failure.
     */
    public func createInvoice(withAccountTitle accountTitle: String, andAccountAddress accountAddress: String, andAmount amount: Int, andMessage message: String, completion: @escaping (_ result: Result, _ invoice: Invoice?) -> Void) {
        
        let newId = self.idForNewInvoice() as NSNumber
        DatabaseManager.sharedInstance.dataStack.perform(
            asynchronous: { (transaction) -> Invoice in
            
                let invoice = transaction.create(Into(Invoice.self))
                invoice.accountTitle = accountTitle
                invoice.accountAddress = accountAddress
                invoice.amount = amount as NSNumber
                invoice.message = message
                invoice.id = newId
                
                return invoice
            },
            success: { (invoiceTransaction) in
                
                let invoice = DatabaseManager.sharedInstance.dataStack.fetchExisting(invoiceTransaction)!
                return completion(.success, invoice)
            },
            failure: { (error) in
                return completion(.failure, nil)
            }
        )
    }
    
    // MARK: - Private Manager Methods
    
    /**
        Determines the id for a new invoice.
     
        - Returns: The id for a new invoice as an integer.
     */
    fileprivate func idForNewInvoice() -> Int {
        
        if let maxID = try? DatabaseManager.sharedInstance.dataStack.queryValue(
            From<Invoice>(),
            Select<Invoice, Int>(.maximum(\.id))
        ) {
            if (maxID == 0) {
                return maxID
            } else {
                return maxID + 1
            }
        } else {
            return 0
        }
    }
}
