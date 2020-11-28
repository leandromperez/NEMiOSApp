//
//  Data + bytes.swift
//  NEMWallet
//
//  Created by Leandro Perez on 28/11/2020.
//  Copyright © 2020 NEM. All rights reserved.
//

import Foundation
extension Data {
    var bytes : [UInt8]{
        return [UInt8](self)
    }
}
