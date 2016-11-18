//
//  ConvertedSocketTest.swift
//  Socket.IO-Client-Swift
//
//  Created by Lukas Schmidt on 25.07.15.
//
//

import XCTest
import Foundation

class SocketEmitTest: AbstractSocketTest {
    override func setUp() {
        super.setUp()
        testKind = TestKind.Emit
        if AbstractSocketTest.socket == nil {
            AbstractSocketTest.socket = SocketIOClient(socketURL: AbstractSocketTest.serverURL, opts: [
                "reconnects": true as AnyObject, // default true
                "reconnectAttempts": -1 as AnyObject, // default -1
                "reconnectWait": 5 as AnyObject, // default 10
                "forcePolling": false as AnyObject,
                "forceWebsockets": false as AnyObject,// default false
                "path": "" as AnyObject]
            )
            openConnection()
        }else {
            AbstractSocketTest.socket.leaveNamespace()
        }
        
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testConnectionStatus() {
        super.checkConnectionStatus()
    }
    
    func testBasic() {
        SocketTestCases.testBasic(socketEmit)
    }
    
    func testNull() {
        SocketTestCases.testNull(socketEmit)
    }
    
    func testBinary() {
        SocketTestCases.testBinary(socketEmit)
    }
    
    func testArray() {
        SocketTestCases.testArray(socketEmit)
    }
    
    func testString() {
        SocketTestCases.testString(socketEmit)
    }
    
    func testBool() {
        SocketTestCases.testBool(socketEmit)
    }
    
    func testInteger() {
        SocketTestCases.testInteger(socketEmit)
    }
    
    func testDouble() {
        SocketTestCases.testDouble(socketEmit)
    }
    
    func testJSON() {
        SocketTestCases.testJSON(socketEmit)
    }
    
    func testJSONWithBuffer() {
        SocketTestCases.testJSONWithBuffer(socketEmit)
    }
    
    func testUnicode() {
        SocketTestCases.testUnicode(socketEmit)
    }
    
    func testMultipleItems() {
        SocketTestCases.testMultipleItems(socketMultipleEmit)
    }
    
    func testMultipleWithBuffer() {
        SocketTestCases.testMultipleItemsWithBuffer(socketMultipleEmit)
    }
    
}
