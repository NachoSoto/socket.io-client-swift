//
//  SocketAckManagerTest.swift
//  Socket.IO-Client-Swift
//
//  Created by Lukas Schmidt on 04.09.15.
//
//

import XCTest

class SocketAckManagerTest: XCTestCase {
    var ackManager = SocketAckManager()
    
    func testAddAcks() {
        let callbackExpection = self.expectation(description: "callbackExpection")
        let itemsArray = ["Hi", "ho"]
        func callback(_ items: [AnyObject]) {
            callbackExpection.fulfill()
        }
        ackManager.addAck(1, callback: callback)
        ackManager.executeAck(1, items: itemsArray as [AnyObject])
        waitForExpectations(timeout: 3.0, handler: nil)
        
    }
}
