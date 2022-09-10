//
//  UserDataManagerTest.swift
//  AutoCataloguerTests
//
//  Created by Sergey on 01.09.2022.
//

import XCTest

@testable import AutoCataloguer

class UserDataManagerTest: XCTestCase {
    
    var sut: UserDataManagerProtocol!
    var user: UserAuthData!
    let defaults = UserDefaults.standard
    
    
    override func setUp()  {
        super.setUp()
        sut = UserDataManager()
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testGetUserFromUDIsCorrect() {
        user = sut.getUserNameFromUserDefaults()
        XCTAssertNotNil(user.userName)
        XCTAssertNotNil(user.userEmail)
        XCTAssertNotNil(user.userPassword)
        XCTAssertNotNil(user.uid)
    }
    
    func testSaveToUserDefaultsIsCorrect() {
        let userTest = UserAuthData(userName: "Bar", userEmail: "bar@baz.ru", userPassword: "", uid: "123456")
        sut.saveUserToUserDefaults(user: userTest)
        user = sut.getUserNameFromUserDefaults()
        XCTAssertEqual(user.userName, userTest.userName)
        XCTAssertEqual(user.userEmail, userTest.userEmail)
        XCTAssertEqual(user.uid, userTest.uid)
        
    }
    
    func testDeleteDataIsCorrect() {
        let userTest = UserAuthData(userName: "Bar", userEmail: "bar@baz.ru", userPassword: "", uid: "123456")
        sut.saveUserToUserDefaults(user: userTest)
        sut.deleteData(user: userTest)
      
        XCTAssertNil(defaults.string(forKey: "userName"))
        XCTAssertNil(defaults.string(forKey: "userEmail"))
        XCTAssertNil(defaults.string(forKey: "uid"))
    }
    
}
