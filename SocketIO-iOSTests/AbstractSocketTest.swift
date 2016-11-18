//
//  AbstractSocketTest.swift
//  AbstractSocketTest.socket.IO-Client-Swift
//
//  Created by Lukas Schmidt on 02.08.15.
//
//

import XCTest

class AbstractSocketTest: XCTestCase {
    static let serverURL = "localhost:6979"
    static let TEST_TIMEOUT = 8.0
    static var socket:SocketIOClient!
    var testKind:TestKind?
    
    
    func openConnection() {
        guard AbstractSocketTest.socket.status == SocketIOClientStatus.notConnected else {return}
        
        weak var expection = self.expectation(description: "connect")
        XCTAssertTrue(AbstractSocketTest.socket.status == SocketIOClientStatus.notConnected)
        AbstractSocketTest.socket.on("connect") {data, ack in
            XCTAssertEqual(AbstractSocketTest.socket.status, SocketIOClientStatus.connected)
            XCTAssertFalse(AbstractSocketTest.socket.secure)
            if let expection = expection {
                expection.fulfill()
            }
        }
        AbstractSocketTest.socket.connect()
        XCTAssertEqual(AbstractSocketTest.socket.status, SocketIOClientStatus.connecting)
        waitForExpectations(timeout: AbstractSocketTest.TEST_TIMEOUT, handler: nil)
    }
    
    func generateTestName(_ rawTestName:String) ->String {
        return rawTestName + testKind!.rawValue
    }
    
    func checkConnectionStatus() {
        XCTAssertEqual(AbstractSocketTest.socket.status, SocketIOClientStatus.connected)
        XCTAssertFalse(AbstractSocketTest.socket.secure)
    }
    
    func socketMultipleEmit(_ testName:String, emitData:Array<AnyObject>, callback:@escaping NormalCallback){
        let finalTestname = generateTestName(testName)
        weak var expection = self.expectation(description: finalTestname)
        func didGetEmit(_ result:[AnyObject], ack:SocketAckEmitter?) {
            callback(result, ack)
            if let expection = expection {
                expection.fulfill()
            }
        }
        
        AbstractSocketTest.socket.emit(finalTestname, withItems: emitData)
        AbstractSocketTest.socket.on(finalTestname + "Return", callback: didGetEmit)
        waitForExpectations(timeout: SocketEmitTest.TEST_TIMEOUT, handler: nil)
    }
    
    
    func socketEmit(_ testName:String, emitData:AnyObject?, callback:@escaping NormalCallback){
        let finalTestname = generateTestName(testName)
        weak var expection = self.expectation(description: finalTestname)
        func didGetEmit(_ result:[AnyObject], ack:SocketAckEmitter?) {
            callback(result, ack)
            if let expection = expection {
                expection.fulfill()
            }
        }
        
        AbstractSocketTest.socket.on(finalTestname + "Return", callback: didGetEmit)
        if let emitData = emitData {
            AbstractSocketTest.socket.emit(finalTestname, emitData)
        } else {
            AbstractSocketTest.socket.emit(finalTestname)
        }
        
        waitForExpectations(timeout: SocketEmitTest.TEST_TIMEOUT, handler: nil)
    }
    
    
    func socketAcknwoledgeMultiple(_ testName:String, Data:Array<AnyObject>, callback:@escaping NormalCallback){
        let finalTestname = generateTestName(testName)
        weak var expection = self.expectation(description: finalTestname)
        func didGetResult(_ result: [AnyObject]) {
            callback(result, SocketAckEmitter(socket: AbstractSocketTest.socket, ackNum: -1))
            if let expection = expection {
                expection.fulfill()
            }
        }
        
        AbstractSocketTest.socket.emitWithAck(finalTestname, withItems: Data)(5, didGetResult)
        waitForExpectations(timeout: SocketEmitTest.TEST_TIMEOUT, handler: nil)
    }
    
    func socketAcknwoledge(_ testName:String, Data:AnyObject?, callback:@escaping NormalCallback){
        let finalTestname = generateTestName(testName)
        weak var expection = self.expectation(description: finalTestname)
        func didGet(_ result:[AnyObject]) {
            callback(result, SocketAckEmitter(socket: AbstractSocketTest.socket, ackNum: -1))
            if let expection = expection {
                expection.fulfill()
            }
        }
        var ack:OnAckCallback!
        if let Data = Data {
            ack = AbstractSocketTest.socket.emitWithAck(finalTestname, Data)
        } else {
            ack = AbstractSocketTest.socket.emitWithAck(finalTestname)
        }
        ack(20, didGet)
        
        waitForExpectations(timeout: SocketEmitTest.TEST_TIMEOUT, handler: nil)
    }
}
