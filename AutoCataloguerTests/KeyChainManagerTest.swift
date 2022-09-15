//
//  KeyChainManagerTest.swift
//  AutoCataloguerTests
//
//  Created by Sergey on 10.09.2022.
//

import XCTest

@testable import AutoCataloguer

class KeyChainManagerTest: XCTestCase {

    var sut: KeychainInputProtocol!
    let user = UserAuthData(userName: "Bar", userEmail: "bar@baz.ru", userPassword: "123456", uid: "12345678")
    let newPassword = "87654321"
    
    override func setUp()  {
        super.setUp()
        sut = KeychainManager()
    }

    override func tearDown() {
       sut = nil
    }

    func testSaveToKeyChainIsCorrect() {
        var saveResult: Bool = false
        let expectation = self.expectation(description: "SavingData")
        sut.deleteUserDataFromKeychain { result in
            switch result {
                
            case .success(_):
                return
            case .failure(let error):
                print(error)
            }
        }
        sut.saveUserDataToKeychain(user: user) { result in
            switch result {
            
            case .success(let result):
                saveResult = result
                expectation.fulfill()
                
            case .failure(let error):
                print(error)
                expectation.fulfill()
                XCTFail()
            }
        }
        waitForExpectations(timeout: 2.0, handler: nil)
        sut.deleteUserDataFromKeychain { result in
            switch result {
                
            case .success(_):
                return
            case .failure(_):
                XCTFail()
                return
            }
        }
        XCTAssertTrue(saveResult)
        
    }
    
    func testDeleteDataFromKeyChainIsCorrect() {
        
        var deleteResult: Bool = false
        let expectation = self.expectation(description: "DeletingData")
        
        sut.loadUserDataFromKeychain(userEmail: user.userEmail) { result in
            switch result {
                
            case .success(_):
                self.sut.deleteUserDataFromKeychain { result in
                    switch result {
                        
                    case .success(_):
                        return
                    case .failure(_):
                        XCTFail()
                        return
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
        
        
        sut.saveUserDataToKeychain(user: user) { result in
            switch result {
                
            case .success(_):
                return
            case .failure(let error):
                print(error)
                XCTFail()
            }
        }
        sut.deleteUserDataFromKeychain { result in
            
            switch result {
                
            case .success(let result):
                deleteResult = result
                expectation.fulfill()
            case .failure(let error):
                print(error)
                expectation.fulfill()
            }
            
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
        XCTAssertTrue(deleteResult)
        
    }
    
    func testLoadUserFromKeyChain() {
        
        var loadResult: Bool = false
        var testUser: UserAuthData!
        let expectation = self.expectation(description: "LoadingData")
        sut.deleteUserDataFromKeychain { result in
            switch result {
                
            case .success(_):
                return
            case .failure(_):
                return
            }
        }
        sut.saveUserDataToKeychain(user: user) { result in
            switch result {
                
            case .success(let result):
                print(result)
            case .failure(let error):
                print(error)
                XCTFail()
            }
        }
        sut.loadUserDataFromKeychain(userEmail: user.userEmail) { result in
            switch result {
                
            case .success(let result):
                testUser = result
                expectation.fulfill()
            case .failure(let error):
                print(error)
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
        guard let test = testUser else {return}
        XCTAssertNotNil(test)
        if test.userName == user.userName && test.userEmail == user.userEmail && test.uid == user.uid && test.userPassword == user.userPassword {
            loadResult = true
        } else {
            XCTFail()
        }
        
        XCTAssertTrue(loadResult)
        
    }
    
    func testUpdatePasswordIsCorrect() {
        
        var updatePasswordResult: Bool = false
        let expectation = self.expectation(description: "UpdatePassword")
        var newUser: UserAuthData!
        
        sut.saveUserDataToKeychain(user: user) { result in
            switch result {
                
            case .success(_):
                return
            case .failure(let error):
                print(error)
                XCTFail()
            }
            
        }
        
        sut.updateUserPassword(newPassword: newPassword) { result in
            switch result {
                
            case .success(_):
                expectation.fulfill()
                return
            case .failure(let error):
                print(error)
                XCTFail()
            }
            
        }
        sut.loadUserDataFromKeychain(userEmail: user.userEmail) { result in
            switch result {
                
            case .success(let user):
                newUser = user
            case .failure(let error):
                print(error)
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
        
        sut.deleteUserDataFromKeychain { result in
            switch result {
                
            case .success(_):
                return
            case .failure(_):
                XCTFail()
                return
            }
        }
        
        XCTAssertEqual(newUser.userPassword, newPassword)
        
    }
    
}
