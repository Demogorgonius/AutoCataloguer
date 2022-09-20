//
//  AlertControllerManagerTest.swift
//  AutoCataloguerTests
//
//  Created by Sergey on 15.09.2022.
//

import XCTest

@testable import AutoCataloguer

class AlertControllerManagerTest: XCTestCase {

    var sut: AlertControllerManagerProtocol!
    let title = "Bar"
    let message = "Baz"
    
    override func setUp() {
        super.setUp()
        sut = AlertControllerManager()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testShowAlertIsCorrect() {
        
        let alert = sut.showAlert(title: title, message: message)
        XCTAssertTrue(alert is UIAlertController)
        XCTAssertEqual(alert.title, title)
        XCTAssertEqual(alert.actions[0].title!, "OK")
        
    }
    
    func testShowAlertQuestionIsCorrect() {
        
        var resultOfAction: Bool!
        
        let alert = sut.showAlertQuestion(title: title, message: message) { result in
            switch result {
                
            case true:
                resultOfAction = true
            case false:
                resultOfAction = false
            }
        }
        
        XCTAssertTrue(alert is UIAlertController)
        XCTAssertEqual(alert.title, title)
        XCTAssertEqual(alert.actions[0].title!, "OK")
        XCTAssertEqual(alert.actions[1].title!, "Cancel")
        
    }
    
    func testShowAlertRegistrationIsCorrect() {
        
        var resultOfAction: Bool!
        
        let alert = sut.showAlertRegistration(title: title, message: message) { (result, userName, email, password, confPassword) in
            switch result {
                
            case true:
                resultOfAction = true
            case false:
                resultOfAction = false
            }
        }
        
        XCTAssertTrue(alert is UIAlertController)
        XCTAssertEqual(alert.title, title)
        XCTAssertEqual(alert.actions[0].title!, "Register")
        XCTAssertEqual(alert.actions[1].title!, "Cancel")
        
    }
    
    func testAlertAuthenticationIsCorrect() {
        
        var resultOFAction: Bool!
        
        let alert = sut.showAlertAuthentication(title: title, message: message) { action, email, password in
            switch action {
                
            case true:
                resultOFAction = true
            case false:
                resultOFAction = false
            }
        }
        
        XCTAssertTrue(alert is UIAlertController)
        XCTAssertEqual(alert.title, title)
        XCTAssertEqual(alert.actions[0].title!, "LogIn")
        XCTAssertEqual(alert.actions[1].title!, "Cancel")
        
    }
    
    func testAlertRememberPasswordIsCorrect() {
        
        var resultOfAction: Bool!
        
        let alert = sut.showAlertRememberPassword(title: title, message: message) { action, email in
            switch action {
                
            case true:
                resultOfAction = true
            case false:
                resultOfAction = false
            }
        }
        
        XCTAssertTrue(alert is UIAlertController)
        XCTAssertEqual(alert.title, title)
        XCTAssertEqual(alert.actions[0].title!, "OK")
        XCTAssertEqual(alert.actions[1].title!, "Cancel")
        
    }
    
    func testAlertDeleteUser() {
        
        var resultOfAction: Bool!
        
        let alert = sut.showAlertDeleteUser(title: title, message: message) { action, email, password in
            switch action {
            case true:
                resultOfAction = true
            case false:
                resultOfAction = false
            }
        }
        
        XCTAssertTrue(alert is UIAlertController)
        XCTAssertEqual(alert.title, title)
        XCTAssertEqual(alert.actions[0].title!, "OK")
        XCTAssertEqual(alert.actions[1].title!, "Cancel")
        
    }
    
    func testAlertChangePasswordIsCorrect() {
        
        var resultOfAction: Bool!
        
        let alert = sut.showAlertChangePassword(title: title, message: message) { action, email, oldPassword, newPassword, confirmNewPassword in
            switch action {
                
            case true:
                resultOfAction = true
            case false:
                resultOfAction = false
            }
        }
        
        XCTAssertTrue(alert is UIAlertController)
        XCTAssertEqual(alert.title, title)
        XCTAssertEqual(alert.actions[0].title!, "Change")
        XCTAssertEqual(alert.actions[1].title!, "Cancel")
        
    }
    

}
