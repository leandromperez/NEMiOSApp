//
//  Observable+ObjectMapper.swift
//
//  Created by Ivan Bruel on 09/12/15.
//  Copyright © 2015 Ivan Bruel. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON


public protocol SwiftyJSONMappable {
    init?(jsonData:JSON)
}

public extension JSON {
    
    /// Maps data received from the signal into an object which implements the ALSwiftyJSONAble protocol.
    /// If the conversion fails, the signal errors.
    func mapObject<T: SwiftyJSONMappable>(_ type:T.Type) throws -> T {
        
        guard let mappedObject = T(jsonData: self) else {
            throw Moya.MoyaError.jsonMapping(Response(statusCode: 200, data: Data()))
        }
        
        return mappedObject
    }
    
    /// Maps data received from the signal into an array of objects which implement the ALSwiftyJSONAble protocol
    /// If the conversion fails, the signal errors.
    func mapArray<T: SwiftyJSONMappable>(_ type:T.Type) throws -> [T] {
        
        let mappedArray = self
        let mappedObjectsArray = mappedArray.arrayValue.compactMap { T(jsonData: $0) }
        
        return mappedObjectsArray
    }
    
}
