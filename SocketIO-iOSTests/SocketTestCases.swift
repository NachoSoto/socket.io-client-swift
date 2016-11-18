//
//  SocketTestCases.swift
//  Socket.IO-Client-Swift
//
//  Created by Lukas Schmidt on 02.08.15.
//
//

import XCTest
import Foundation

class SocketTestCases: NSObject {
    typealias SocketSendFunction = (_ testName:String, _ emitData:AnyObject?, _ callback: @escaping NormalCallback)->()
    
    static func testBasic(_ abstractSocketSend:SocketSendFunction) {
        let testName = "basicTest"
        func didGetResult(_ result:[AnyObject], ack:SocketAckEmitter?) {
            
        }
        abstractSocketSend(testName, nil, didGetResult)
    }
    
    static func testNull(_ abstractSocketSend:SocketSendFunction) {
        let testName = "testNull"
        func didGetResult(_ result:[AnyObject], ack:SocketAckEmitter?) {
            if let _ = result.first as? NSNull {
                
            }else
            {
                XCTFail("Should have NSNull as result")
            }
        }
        abstractSocketSend(testName, NSNull(), didGetResult)
    }
    
    static func testBinary(_ abstractSocketSend:SocketSendFunction) {
        let testName = "testBinary"
        func didGetResult(_ result:[AnyObject], ack:SocketAckEmitter?) {
            if let data = result.first as? Data {
                let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
                XCTAssertEqual(string, "gakgakgak2")
            }else {
                XCTFail("Should have NSData as result")
            }
        }
        let data = (NSString(string: "gakgakgak2") as String).data(using: .utf8)!
        abstractSocketSend(testName, data as AnyObject?, didGetResult)
    }
    
    static func testArray(_ abstractSocketSend:SocketSendFunction) {
        let testName = "testArray"
        func didGetResult(_ result:[AnyObject], ack:SocketAckEmitter?) {
            if let array = result.first as? NSArray {
                XCTAssertEqual(array.count, 2)
                XCTAssertEqual((array.firstObject! as! String), "test3")
                XCTAssertEqual((array.lastObject! as! String), "test4")
            }else {
                XCTFail("Should have NSArray as result")
            }
        }
        abstractSocketSend(testName, ["test1", "test2"] as AnyObject, didGetResult)
    }
    
    static func testString(_ abstractSocketSend:SocketSendFunction) {
        let testName = "testString"
        func didGetResult(_ result:[AnyObject], ack:SocketAckEmitter?) {
            if let string = result.first as? String {
                XCTAssertEqual(string, "polo")
            }else {
                XCTFail("Should have String as result")
            }
        }
        abstractSocketSend(testName, "marco" as AnyObject?, didGetResult)
    }
    
    static func testBool(_ abstractSocketSend:SocketSendFunction) {
        let testName = "testBool"
        func didGetResult(_ result:[AnyObject], ack:SocketAckEmitter?) {
            if let bool = result.first as? NSNumber {
                XCTAssertTrue(bool.boolValue)
            }else {
                XCTFail("Should have Boolean as result")
            }
        }
        abstractSocketSend(testName, false as AnyObject?, didGetResult)
    }
    
    static func testInteger(_ abstractSocketSend:SocketSendFunction) {
        let testName = "testInteger"
        func didGetResult(_ result:[AnyObject], ack:SocketAckEmitter?) {
            if let integer = result.first as? Int {
                XCTAssertEqual(integer, 20)
            }else {
                XCTFail("Should have Integer as result")
            }
        }
        abstractSocketSend(testName, 10 as AnyObject?, didGetResult)
    }
    
    static func testDouble(_ abstractSocketSend:SocketSendFunction) {
        let testName = "testDouble"
        func didGetResult(_ result:[AnyObject], ack:SocketAckEmitter?) {
            if let double = result.first as? NSNumber {
                XCTAssertEqual(double.floatValue, 1.2)
            }else {
                XCTFail("Should have Double as result")
            }
        }
        abstractSocketSend(testName, 1.1 as AnyObject?, didGetResult)
    }
    
    static func testJSONWithBuffer(_ abstractSocketSend:SocketSendFunction) {
        let testName = "testJSONWithBuffer"
        let data = "0".data(using: String.Encoding.utf8, allowLossyConversion: false)!
        
        func didGetResult(_ result:[AnyObject], ack:SocketAckEmitter?) {
            if let json = result.first as? NSDictionary {
                XCTAssertEqual((json.value(forKey: "testString")! as! String), "test")
                XCTAssertEqual((json.value(forKey: "testNumber")! as! Int), 15)
                XCTAssertEqual((json.value(forKey: "testArray")! as! Array<AnyObject>).count, 2)
                XCTAssertEqual(((json.value(forKey: "testArray")! as! Array<AnyObject>).last! as! Int), 1)
                let string = NSString(data: (json.value(forKey: "testArray")! as! Array<AnyObject>).first! as! Data, encoding: String.Encoding.utf8.rawValue)!
                XCTAssertEqual(string, "gakgakgak2")
            }else {
                XCTFail("Should have NSDictionary as result")
            }
        }
        let json = ["name": "test", "testArray": ["hallo"], "nestedTest": ["test": "test"], "number": 15, "buf": data] as [String : Any]
        
        abstractSocketSend(testName, json as AnyObject?, didGetResult)
    }
    
    static func testJSON(_ abstractSocketSend:SocketSendFunction) {
        let testName = "testJSON"
        func didGetResult(_ result:[AnyObject], ack:SocketAckEmitter?) {
            if let json = result.first as? NSDictionary {
                XCTAssertEqual((json.value(forKey: "testString")! as! String), "test")
                XCTAssertEqual(json.value(forKey: "testNumber")! as? Int, 15)
                XCTAssertEqual((json.value(forKey: "testArray")! as! Array<AnyObject>).count, 2)
                XCTAssertEqual((json.value(forKey: "testArray")! as! Array<AnyObject>).first! as? Int, 1)
                XCTAssertEqual((json.value(forKey: "testArray")! as! Array<AnyObject>).last! as? Int, 1)
                
            }else {
                XCTFail("Should have NSDictionary as result")
            }
        }
        let json = ["name": "test", "testArray": ["hallo"], "nestedTest": ["test": "test"], "number": 15] as [String : Any]
        
        abstractSocketSend(testName, json as AnyObject?, didGetResult)
    }
    
    static func testUnicode(_ abstractSocketSend:SocketSendFunction) {
        let testName = "testUnicode"
        func didGetResult(_ result:[AnyObject], ack:SocketAckEmitter?) {
            if let unicode = result.first as? String {
                XCTAssertEqual(unicode, "🚄")
            }else {
                XCTFail("Should have String as result")
            }
        }
        abstractSocketSend(testName, "🚀" as AnyObject?, didGetResult)
    }
    
    static func testMultipleItemsWithBuffer(_ abstractSocketMultipleSend:(_ testName:String, _ emitData:Array<AnyObject>, _ callback: @escaping NormalCallback)->()) {
        let testName = "testMultipleItemsWithBuffer"
        func didGetResult(_ result:[AnyObject], ack:SocketAckEmitter?) {
            XCTAssertEqual(result.count, 5)
            if result.count != 5 {
                XCTFail("Fatal Fail. Lost some Data")
                return
            }
            if let array = result.first as? Array<AnyObject> {
                XCTAssertEqual((array.last! as! Int), 2)
                XCTAssertEqual((array.first! as! Int), 1)
            }else {
                XCTFail("Should have Array as result")
            }
            if let dict = result[1] as? NSDictionary {
                XCTAssertEqual((dict.value(forKey: "test") as! String), "bob")
                
            }else {
                XCTFail("Should have NSDictionary as result")
            }
            if let number = result[2] as? Int {
                XCTAssertEqual(number, 25)
                
            }else {
                XCTFail("Should have Integer as result")
            }
            if let string = result[3] as? String {
                XCTAssertEqual(string, "polo")
                
            }else {
                XCTFail("Should have Integer as result")
            }
            if let data = result[4] as? Data {
                let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
                XCTAssertEqual(string, "gakgakgak2")
            }else {
                XCTFail("Should have NSData as result")
            }
        }
        let data = (NSString(string: "gakgakgak2") as String).data(using: .utf8)!
        let emitArray = [["test1", "test2"], ["test": "test"], 15, "marco", data] as [Any]
        abstractSocketMultipleSend(testName, emitArray as [AnyObject], didGetResult)
    }
    
    static func testMultipleItems(_ abstractSocketMultipleSend:(_ testName:String, _ emitData:Array<AnyObject>, _ callback: @escaping NormalCallback)->()) {
        let testName = "testMultipleItems"
        func didGetResult(_ result:[AnyObject], ack:SocketAckEmitter?) {
            XCTAssertEqual(result.count, 5)
            if result.count != 5 {
                XCTFail("Fatal Fail. Lost some Data")
                return
            }
            if let array = result.first as? Array<AnyObject> {
                XCTAssertEqual((array.last! as! Int), 2)
                XCTAssertEqual((array.first! as! Int), 1)
            }else {
                XCTFail("Should have Array as result")
            }
            if let dict = result[1] as? NSDictionary {
                XCTAssertEqual((dict.value(forKey: "test") as! String), "bob")
                
            }else {
                XCTFail("Should have NSDictionary as result")
            }
            if let number = result[2] as? Int {
                XCTAssertEqual(number, 25)
                
            }else {
                XCTFail("Should have Integer as result")
            }
            if let string = result[3] as? String {
                XCTAssertEqual(string, "polo")
            }else {
                XCTFail("Should have Integer as result")
            }
            if let bool = result[4] as? NSNumber {
                XCTAssertFalse(bool.boolValue)
            }else {
                XCTFail("Should have NSNumber as result")
            }
        }
        let emitArray = [["test1", "test2"], ["test": "test"], 15, "marco", false] as [Any]
        abstractSocketMultipleSend(testName, emitArray as Array<AnyObject>, didGetResult)
    }
}
