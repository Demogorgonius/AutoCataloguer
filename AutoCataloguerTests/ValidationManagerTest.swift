//
//  ValidationManagerTest.swift
//  AutoCataloguerTests
//
//  Created by Sergey on 25.08.2022.
//

import XCTest

@testable import AutoCataloguer

class ValidationManagerTest: XCTestCase {

    var sut: ValidatorClass!
    
    override func setUp() {
        super.setUp()
        sut = ValidatorClass()
    }

    override func tearDown() {
        sut = nil
    }

    func testValidatorStringEmailCorrect(){
        
        let emailString = ""
        var result: Bool?
        
        do {
            result = try sut.checkString(stringType: .email, string: emailString, stringForMatching: nil)
        } catch {
            _ = error
        }
        
        XCTAssertNil(result)
        XCTAssertFalse((result != nil))
    }
    
    func testValidationStringPasswordCorrect() {
        
        let passwordString = "sdf"
        var result: Bool?
                
        do {
            
            result = try sut.checkString(stringType: .password, string: passwordString, stringForMatching: nil)
            
        } catch {
            _ = error
        }
        
        XCTAssertNil(result)
        XCTAssertFalse((result != nil))
        
    }
    
    func testValidationStringUserNameCorrect() {
        
        let userNameString = "0"
        var result: Bool?
        
        do {
            
            result = try sut.checkString(stringType: .userName, string: userNameString, stringForMatching: nil)
            
        } catch {
            _ = error
        }
        
        XCTAssertNil(result)
        XCTAssertFalse((result != nil))
    }
    
    func testValidationStringMatching() {
        
        let stringOriginal = "1"
        let stringForMatching = "2"
        var result: Bool?
        
        do {
            result = try sut.checkString(stringType: .passwordMatch, string: stringOriginal, stringForMatching: stringForMatching)
        } catch {
            _ = error
        }
        
        XCTAssertNil(result)
        XCTAssertFalse((result != nil))
        
    }
    
    
    func testValidationEmptyString() {
        
        let string: String = ""
        var result: Bool?
        do {
            
            result = try sut.checkString(stringType: .emptyString, string: string, stringForMatching: nil)
            
        } catch {
            _ = error
        }
        
        XCTAssertNil(result)
        XCTAssertFalse((result != nil))
        
    }


}
