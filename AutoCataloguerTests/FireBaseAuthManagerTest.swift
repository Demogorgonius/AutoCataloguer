//
//  FireBaseAuthManagerTest.swift
//  AutoCataloguerTests
//
//  Created by Sergey on 07.11.2022.
//

import XCTest
import Firebase
import FirebaseAuth

@testable import AutoCataloguer

final class FireBaseAuthManagerTest: XCTestCase {
    
    var sut: FireBaseAuthInputProtocol!
    
    let user = UserAuthData(
        userName: "Baz",
        userEmail: "baz@test.ru",
        userPassword: "123456789",
        uid: "")
    let userNew = UserAuthData(
        userName: "Bas",
        userEmail: "bas@test.ru",
        userPassword: "123456789",
        uid: "")
    var returnUser: UserAuthData!
    var returnUserNew: UserAuthData!
    var currentUser: UserAuthData!
    var resultCheckingCurrentUser: Bool = false
    let newPassword: String = "987654321"
    var testUserArray: [UserAuthData] = []
    let wrongEmail: String = "bas@test.ru"
    var wrongEmailStatus: Bool = true
    
    override func setUp() {
        super.setUp()
        sut = FireBaseAuthManager()
    }
    
    override func tearDown() {
        super.tearDown()
        
//        repeat {
//            for userFromArray in testUserArray {
//                do {
//                    try Auth.auth().signOut()
//                } catch let error as NSError {
//                    print("SignOut ERROR: \(error)")
//                }
//
//                Auth.auth().signIn(withEmail: userFromArray.userEmail, password: userFromArray.userPassword) { (result, error) in
//
//                    if let error = error {
//                        print("SignIn ERROR: \(error)")
//                    } else {
//                        if let curUser = Auth.auth().currentUser {
//                            curUser.delete { error in
//                                if let error = error {
//                                    print("Deleting user \(curUser.displayName ?? "") ERROR: \(error)")
//                                } else {
//                                    if let userIndex = self.testUserArray.firstIndex(where: {$0.userEmail == userFromArray.userEmail}) {
//                                        self.testUserArray.remove(at: userIndex)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//
//            }
//        } while testUserArray.count != 0
        for userFromArray in testUserArray {
            if let curUser = Auth.auth().currentUser {
                if curUser.email == userFromArray.userEmail {
                    curUser.delete { error in
                        if let error = error { print("Deleting user ERROR: %@", error) } else {
                            if let userIndex = self.testUserArray.firstIndex(where: {$0.userEmail == userFromArray.userEmail}) {
                                self.testUserArray.remove(at: userIndex)
                            }
                        }
                    }
                } else {
                    sut.signOut { result in
                        switch result {
                        case .success(_):
                            Auth.auth().signIn(withEmail: userFromArray.userEmail, password: userFromArray.userPassword) { (result, error) in
                                if let error = error { print("SignIn ERROR: \(error)") } else {
                                    if let result = result {
                                        result.user.delete { error in
                                            if let error = error { print("Deleting user ERROR: \(error)") } else {
                                                if let userIndex = self.testUserArray.firstIndex(where: {$0.userEmail == userFromArray.userEmail}) {
                                                    self.testUserArray.remove(at: userIndex)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        case .failure(let error as NSError):
                            print("SignOut ERROR: %@", error)
                        }
                    }

                }
            }
        }

        returnUser = nil
        returnUserNew = nil
        currentUser = nil
 //       testUserArray.removeAll()
        resultCheckingCurrentUser = false
        wrongEmailStatus = true
        
    }
    
    func testCreateUserIsCorrect() {
        
        let expectation = self.expectation(description: "Creating FireBase user")
        testUserArray.append(user)
        sut.createUser(userName: user.userName, email: user.userEmail, password: user.userPassword) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.returnUser = user
                expectation.fulfill()
            case .failure(let error):
                print(error)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10.0, handler: nil)
        XCTAssertNotNil(returnUser)
        XCTAssertEqual(user.userName, returnUser.userName)
        XCTAssertEqual(user.userEmail, returnUser.userEmail)
        XCTAssertEqual(user.userPassword, returnUser.userPassword)
    }
    
    func testSingInIsCorrect() {
        
        let expectation = self.expectation(description: "SingIn with user auth data")
        testUserArray.append(user)
        Auth.auth().createUser(withEmail: user.userEmail, password: user.userPassword) { (authResult, error) in
            if let error = error {
                print("Creating user ERROR: \(error)")
                return
            } else {
                if let curUser = Auth.auth().currentUser?.createProfileChangeRequest() {
                    curUser.displayName = self.user.userName
                    curUser.commitChanges { [self] (error) in
                        if let error = error {
                            print("User changing auth data ERROR: \(error)")
                        } else {
                            if let curUser = Auth.auth().currentUser {
                                self.currentUser = UserAuthData(userName: curUser.displayName ?? "",
                                                    userEmail: curUser.email!,
                                                    userPassword: user.userPassword,
                                                    uid: curUser.uid)
                                do {
                                    try Auth.auth().signOut()
                                } catch let error as NSError {
                                    print("SignOUT ERROR: \(error)")
                                }
                                if Auth.auth().currentUser == nil {
                                    sut.signIn(email: user.userEmail, password: user.userPassword) { [weak self] result in
                                        guard let self = self else { return }
                                        switch result {
                                        case .success(let user):
                                            self.returnUser = user
                                            expectation.fulfill()
                                        case .failure(let error):
                                            print("SignIn user ERROR: \(error)")
                                            expectation.fulfill()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        waitForExpectations(timeout: 5.0, handler: nil)
        XCTAssertNotNil(returnUser)
        XCTAssertNotNil(currentUser)
       XCTAssertEqual(currentUser.userEmail, returnUser.userEmail)
        
    }
    
    func testRestorePasswordWrongEmail() {
        let expectation = self.expectation(description: "Testing wrong e-mail...")
        testUserArray.append(user)
        Auth.auth().createUser(withEmail: user.userEmail, password: user.userPassword) { [weak self] (result, error) in
            guard let self = self else { return }
            if let error = error {
                print("Creating user ERROR: \(error)")
            } else {
                if let curUser = Auth.auth().currentUser?.createProfileChangeRequest() {
                    curUser.displayName = self.user.userName
                    curUser.commitChanges { error in
                        if let error = error {
                            print("User changing auth data ERROR: \(error)")
                        } else {
                            if let curUser = Auth.auth().currentUser {
                                self.currentUser = UserAuthData(userName: curUser.displayName ?? "",
                                                                userEmail: curUser.email!,
                                                                userPassword: self.user.userPassword,
                                                                uid: curUser.uid)
                            }
                            self.sut.restorePassword(email: self.wrongEmail) { [weak self] result in
                                guard let self = self else { return }
                                switch result {
                                case .success(_):
                                    self.wrongEmailStatus = true
                                    expectation.fulfill()
                                case .failure(let error):
                                    self.wrongEmailStatus = false
                                    print("Sending e-mail ERROR: \(error)")
                                    expectation.fulfill()
                                }
                            }
                        }
                    }
                    
                }
            }
        }
        waitForExpectations(timeout: 5.0, handler: nil)
        XCTAssertFalse(wrongEmailStatus)    
    }
    
    func testChangingPasswordIsCorrect() {
        testUserArray.append(user)
        let expectation = self.expectation(description: "Testing changing password for user.")
        Auth.auth().createUser(withEmail: user.userEmail, password: user.userPassword) { [weak self] (result, error) in
            guard let self = self else { return }
            if let error = error {
                print("Creating user ERROR: \(error)")
            } else {
                if let curUser = Auth.auth().currentUser?.createProfileChangeRequest() {
                    curUser.displayName = self.user.userName
                    curUser.commitChanges { error in
                        if let error = error {
                            print("User changing auth data ERROR: \(error)")
                        } else {
                            if let curUser = Auth.auth().currentUser {
                                self.currentUser = UserAuthData(userName: curUser.displayName ?? "",
                                                                userEmail: curUser.email!,
                                                                userPassword: self.user.userPassword,
                                                                uid: curUser.uid)
                            }
                            self.sut.changePassword(newPassword: self.newPassword) { [weak self] result in
                                guard let self = self else { return }
                                switch result {
                                case .success(_):
                                    self.testUserArray[0].userPassword = self.newPassword
                                    do {
                                        try Auth.auth().signOut()
                                    } catch let error as NSError {
                                        print("Sign out ERROR: \(error)")
                                    }
                                    self.sut.signIn(email: self.user.userEmail, password: self.newPassword) { [weak self] result in
                                        guard let self = self else { return }
                                        switch result {
                                        case .success(_):
                                            self.resultCheckingCurrentUser = true
                                            expectation.fulfill()
                                        case .failure(let error):
                                            print("Sign in ERROR: \(error)")
                                            expectation.fulfill()
                                        }
                                    }
                                case .failure(let error):
                                    print("Change user password ERROR: \(error)")
                                }
                            }
                        }
                    }
                }
            }
        }
        waitForExpectations(timeout: 5.0, handler: nil)
        XCTAssertTrue(resultCheckingCurrentUser)
        
    }
    
    func testDeletingUserIsCorrect() {
        
        testUserArray.append(user)
        let expectation = self.expectation(description: "Deleting user from firebase.")
        Auth.auth().createUser(withEmail: user.userEmail, password: user.userPassword) { [weak self] (result, error) in
            guard let self = self else { return }
            if let error = error {
                print("Creating new firebase user ERROR: \(error)")
            } else {
                if let curUser = Auth.auth().currentUser?.createProfileChangeRequest() {
                    curUser.displayName = self.user.userName
                    curUser.commitChanges { error in
                        if let error = error {
                            print("User changing auth data ERROR: \(error)")
                        } else {
                            if Auth.auth().currentUser != nil {
                                self.sut.deleteUser { [weak self] result in
                                    guard let self = self else { return }
                                    switch result {
                                    case .success(_):
                                        if Auth.auth().currentUser == nil {
                                            self.resultCheckingCurrentUser = true
                                            self.testUserArray.remove(at: 0)
                                            expectation.fulfill()
                                        } else {
                                            self.resultCheckingCurrentUser = false
                                            expectation.fulfill()
                                        }
                                    case .failure(let error):
                                        print("Deleting user ERROR: \(error)")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
        XCTAssertTrue(resultCheckingCurrentUser)
        
    }
    
    func testCheckingCurrentUserIsCorrect() {
        
        testUserArray.append(user)
        let expectation = self.expectation(description: "Checking current user")
        Auth.auth().createUser(withEmail: user.userEmail, password: user.userPassword) { [weak self] (result, error) in
            guard let self = self else { return }
            if let error = error {
                print("Creating new user ERROR: \(error)")
            } else {
                if let curUser = Auth.auth().currentUser?.createProfileChangeRequest() {
                    curUser.displayName = self.user.userName
                    curUser.commitChanges { error in
                        if let error = error {
                            print("Commit changes for new user ERROR: \(error)")
                        } else {
                            self.sut.checkCurrentUser(email: self.user.userEmail, password: self.user.userPassword) { [weak self] result in
                                guard let self = self else { return }
                                switch result {
                                case .success(_):
                                    self.resultCheckingCurrentUser = true
                                    expectation.fulfill()
                                case .failure(let error):
                                    print("Checking user ERROR: \(error)")
                                    expectation.fulfill()
                                }
                            }
                        }
                    }
                }
            }
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
        XCTAssertTrue(resultCheckingCurrentUser)
    }
    
    func testСheckSignInAnotherUser() {
        testUserArray.append(user)
        testUserArray.append(userNew)
        let expectation = self.expectation(description: "Check SignIn...")
        Auth.auth().createUser(withEmail: user.userEmail, password: user.userPassword) { [weak self] (result, error) in
            guard let self = self else { return }
            if let error = error {
                print("Creating user ERROR: \(error)")
            } else {
                if let curUser = Auth.auth().currentUser?.createProfileChangeRequest() {
                    curUser.displayName = self.user.userName
                    curUser.commitChanges { error in
                        if let error = error {
                            print("Commit changes for new user ERROR: \(error)")
                        } else {
                            Auth.auth().createUser(withEmail: self.userNew.userEmail, password: self.userNew.userPassword) { [weak self] (result, error) in
                                guard let self = self else { return }
                                if let error = error {
                                    print("Creating userNew ERROR: \(error)")
                                } else {
                                    if let curUser = Auth.auth().currentUser?.createProfileChangeRequest() {
                                        curUser.displayName = self.userNew.userName
                                        curUser.commitChanges { error in
                                            if let error = error {
                                                print("Commit changes for new user ERROR: \(error)")
                                            } else {
                                                
                                                do {
                                                    try Auth.auth().signOut()
                                                } catch let error as NSError {
                                                    print("SignOut ERROR: \(error)")
                                                }
                                                
                                                self.sut.checkCurrentUser(email: self.user.userEmail, password: self.user.userPassword) { [weak self] result in
                                                    guard let self = self else { return }
                                                    switch result {
                                                    case .success(_):
                                                        if let curUser = Auth.auth().currentUser {
                                                            if curUser.email == self.user.userEmail {
                                                                self.resultCheckingCurrentUser = true
                                                                expectation.fulfill()
                                                            } else {
                                                                self.resultCheckingCurrentUser = false
                                                                expectation.fulfill()
                                                            }
                                                        }
                                                    case .failure(let error):
                                                        print("Check user ERROR: \(error)")
                                                        XCTFail("Check error!!!")
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        waitForExpectations(timeout: 225.0, handler: nil)
        XCTAssertTrue(resultCheckingCurrentUser)
    }
    
}
