import UIKit
//import CryptoSwift


struct AES {

    // MARK: - Value
    // MARK: Private
    private let key: Data
    private let iv: Data


    // MARK: - Initialzier
    init?(key: Data, iv: Data) {
        guard key.count == kCCKeySizeAES128 || key.count == kCCKeySizeAES256 else {
            debugPrint("Error: Failed to set a key.")
            return nil
        }

        guard iv.count == kCCBlockSizeAES128 else {
            debugPrint("Error: Failed to set an initial vector.")
            return nil
        }

        self.key = key
        self.iv  = iv
    }
    
    init?(key: String, iv: String) {
        guard key.count == kCCKeySizeAES128 || key.count == kCCKeySizeAES256, let keyData = key.data(using: .utf8) else {
            debugPrint("Error: Failed to set a key.")
            return nil
        }

        guard iv.count == kCCBlockSizeAES128, let ivData = iv.data(using: .utf8) else {
            debugPrint("Error: Failed to set an initial vector.")
            return nil
        }


        self.key = keyData
        self.iv  = ivData
    }


    // MARK: - Function
    // MARK: Public
    func encrypt(string: String) -> Data? {
        string.data(using: .utf8).flatMap(encrypt(data:))
    }
    
    func encrypt(data: Data) -> Data? {
        return crypt(data: data, option: CCOperation(kCCEncrypt))
    }

    func decrypt(data: Data?) -> Data? {
        return crypt(data: data, option: CCOperation(kCCDecrypt)) 
    }

    func crypt(data: Data?, option: CCOperation) -> Data? {
        guard let data = data else { return nil }

        let cryptLength = data.count + kCCBlockSizeAES128
        var cryptData   = Data(count: cryptLength)

        let keyLength = key.count
        let options   = CCOptions(kCCOptionPKCS7Padding)

        var bytesLength = Int(0)

        let status = cryptData.withUnsafeMutableBytes { cryptBytes in
            data.withUnsafeBytes { dataBytes in
                iv.withUnsafeBytes { ivBytes in
                    key.withUnsafeBytes { keyBytes in
                    CCCrypt(option, CCAlgorithm(kCCAlgorithmAES), options, keyBytes.baseAddress, keyLength, ivBytes.baseAddress, dataBytes.baseAddress, data.count, cryptBytes.baseAddress, cryptLength, &bytesLength)
                    }
                }
            }
        }

        guard UInt32(status) == UInt32(kCCSuccess) else {
            debugPrint("Error: Failed to crypt data. Status \(status)")
            return nil
        }

        cryptData.removeSubrange(bytesLength..<cryptData.count)
        return cryptData
    }
}

extension NSData
{
    func hexadecimalString() -> String {
        let string = NSMutableString(capacity: length * 2)
        var byte: UInt8 = UInt8()
        
        for i in 0 ..< length {
            getBytes(&byte, range: NSMakeRange(i, 1))
            string.appendFormat("%02x", byte)
        }
        
        return string as NSString as String
    }
    
    func aesEncrypt(key: [UInt8], iv: [UInt8]) -> NSData? {
        let enc = AES(key: key.data, iv: iv.data)?.encrypt(data: self as Data)
        return enc.flatMap(NSData.init(data:))
//        return enc as NSData
//        let enc = try! AES(key: key, blockMode: CBC(iv: iv)).encrypt(self.arrayOfBytes())
//        let encData = NSData(bytes: enc, length: enc.count)

//        return encData
    }
    
    func aesDecrypt(key: [UInt8], iv: [UInt8]) -> NSData? {
        do {
            let dec = AES(key: key.data, iv: iv.data)?.decrypt(data: self as Data)
            return dec.flatMap(NSData.init(data:))

//            let dec = try AES(key: key, blockMode: CBC(iv: iv)).decrypt(self.arrayOfBytes())
//            let decData = NSData(bytes: dec, length: dec.count)
//            return decData
        } catch let error {
            print(error)
            return nil
        }
        
    }
    
    public func arrayOfBytes() -> Array<UInt8> {
        let count = self.length / MemoryLayout<UInt8>.size
        var bytesArray = Array<UInt8>(repeating: 0, count: count)
        self.getBytes(&bytesArray, length:count * MemoryLayout<UInt8>.size)
        return bytesArray
    }
}
