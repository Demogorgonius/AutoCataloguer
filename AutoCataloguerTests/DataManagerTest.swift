//
//  DataManagerTest.swift
//  AutoCataloguerTests
//
//  Created by Sergey on 22.09.2022.
//

import XCTest
import CoreData

@testable import AutoCataloguer

final class DataManagerTest: XCTestCase {
    
    var sut: DataManagerProtocol!
    var testAllCatalogue: [Catalogues]!
    var testAllElements: [Element]!
    var testAllDeletedElements: [Element]!
    var testAllExistingElements: [Element]!
    var testAllNoCatalogueElements: [Element]!
    var testCatalogueForSave: Catalogues!
    var testElementForSave: Element!
    var testCatalogue: Catalogues!
    var testElement: Element!
    var testCatalogueForSaveNew: Catalogues!
    
    
    
    
    override func setUp() {
        
        super.setUp()
        let coreDataManager = CoreDataManager()
        let context = coreDataManager.context
        sut = DataManagerClass(context: context)
    }
    
    override func tearDown() {
        if testCatalogueForSave != nil {
            sut.getCatalogue(catalogueName: "test") { [weak self] result in
                guard let self = self else {return}
                switch result {
                case .success(let catalogue):
                    self.testCatalogueForSave = catalogue
                case .failure(let error):
                    print(error)
                }
            }
            
            if testElementForSave != nil {
                sut.getElementsFromCatalogue(catalogue: testCatalogueForSave, display: .allElement) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let elements):
                        if elements.count != 0 {
                            self.testElementForSave = elements[0]
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
                
                if testElementForSave.isDeletedElement == false {
                    
                    sut.markElementAsDeleted(element: testElementForSave) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success(let element):
                            self.testElementForSave = element
                        case .failure(let error):
                            print(error)
                        }
                    }
                    
                }
                sut.deleteElement(element: testElementForSave) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(_):
                        self.testElementForSave = nil
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            
            sut.deleteCatalogue(catalogue: testCatalogueForSave) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(_):
                    self.testCatalogueForSave = nil
                case .failure(let error):
                    print(error)
                }
            }
            
        }
        if testCatalogueForSaveNew != nil {
            sut.getCatalogue(catalogueName: "testNew") { [weak self] result in
                guard let self = self else {return}
                switch result {
                case .success(let catalogue):
                    self.testCatalogueForSaveNew = catalogue
                case .failure(let error):
                    print(error)
                }
            }
            
            if testElementForSave != nil {
                sut.getElementsFromCatalogue(catalogue: testCatalogueForSaveNew, display: .allElement) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let elements):
                        if elements.count != 0 {
                            self.testElementForSave = elements[0]
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
                
                if testElementForSave.isDeletedElement == false {
                    
                    sut.markElementAsDeleted(element: testElementForSave) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success(let element):
                            self.testElementForSave = element
                        case .failure(let error):
                            print(error)
                        }
                    }
                    
                }
                sut.deleteElement(element: testElementForSave) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(_):
                        self.testElementForSave = nil
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            
            sut.deleteCatalogue(catalogue: testCatalogueForSaveNew) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(_):
                    self.testCatalogueForSaveNew = nil
                case .failure(let error):
                    print(error)
                }
            }
            
        }
        
        if testElementForSave != nil {
            
            sut.getAllElements(display: .allElement) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let elements):
                    self.testAllElements = elements
                case .failure(let error):
                    print(error)
                }
            }
            
            for element in testAllElements {
                if element.title == "Bar" || element.title == "" {
                    sut.markElementAsDeleted(element: element) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success(let element):
                            self.testElementForSave = element
                        case .failure(let error):
                            print(error)
                        }
                    }
                    sut.deleteElement(element: element) { [weak self] result in
                        guard let self = self else {return}
                        switch result {
                        case .success(_):
                            self.testElementForSave = nil
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            }
            
        }
        
        sut = nil
        testCatalogue = nil
        
    }
    
    func testSaveCatalogueIsCorrect() {
        let expectation = self.expectation(description: "savingCatalogue")
        sut.saveCatalogue(catalogueName: "test", catalogueType: CatalogueType.box.rawValue, cataloguePlace: "testRoom", catalogueIsFull: true) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let catalogue):
                self.testCatalogueForSave = catalogue
                expectation.fulfill()
            case .failure(let error):
                print(error)
                expectation.fulfill()
            }
            
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
        XCTAssertNotNil(testCatalogueForSave)
        XCTAssertTrue(testCatalogueForSave.isFull == true)
        XCTAssertTrue(testCatalogueForSave.nameCatalogue == "test")
        XCTAssertTrue(testCatalogueForSave.isDeletedCatalogue == false)
        XCTAssertTrue(testCatalogueForSave.typeOfCatalogue == CatalogueType.box.rawValue)
        XCTAssertTrue(testCatalogueForSave.placeOfCatalogue == "testRoom")
        
    }
    
    func testSaveElementIsCorrect() {
        
        let expectation = self.expectation(description: "savingElement")
        
        sut.getCatalogue(catalogueName: "test") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let catalogue):
                self.testCatalogueForSave = catalogue
            case .failure(let error):
                print(error)
            }
        }
        if testCatalogueForSave == nil ||  testCatalogueForSave.nameCatalogue != "test" {
            sut.saveCatalogue(catalogueName: "test", catalogueType: CatalogueType.box.rawValue, cataloguePlace: "testRoom", catalogueIsFull: true) { [weak self] result in
                guard let self = self else {return}
                switch result {
                case .success(let catalogue):
                    self.testCatalogueForSave = catalogue
                case .failure(let error):
                    print(error)
                }
                
            }
        }
        sut.saveElement(elementType: ElementType.book.rawValue, elementAuthor: "Bas", elementRealiseDate: "9999", elementTitle: "Bar", elementDescription: "Baz", elementParentCatalogue: "test", catalogue: testCatalogueForSave, elementCoverPhoto: nil, elementFirstPagePhoto: nil) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let element):
                self.testElementForSave = element
                expectation.fulfill()
            case .failure(let error):
                print(error)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
        XCTAssertNotNil(testElementForSave)
        XCTAssertTrue(testElementForSave.type == ElementType.book.rawValue)
        XCTAssertTrue(testElementForSave.author == "Bas")
        XCTAssertTrue(testElementForSave.releaseDate == "9999")
        XCTAssertTrue(testElementForSave.elementDescription == "Baz")
        XCTAssertTrue(testElementForSave.parentCatalogue == "test")
        XCTAssertNil(testElementForSave.coverImage)
        XCTAssertNil(testElementForSave.pageImage)
        
    }
    
    func testGetAllCatalogueReturnTheCataloguesArray() {
        
        let expectation = self.expectation(description: "Getting All Catalogues")
        
        sut.getAllCatalogue { [weak self] result in
            
            guard let self = self else { return }
            switch result {
            case .success(let catalogues):
                self.testAllCatalogue = catalogues
                expectation.fulfill()
            case .failure(let error):
                print(error)
                expectation.fulfill()
            }
            
        }
        waitForExpectations(timeout: 2.0, handler: nil)
        XCTAssertNotNil(testAllCatalogue)
        
    }
    
    func testGetAllElementsReturnTheElementsArray() {
        let expectation = self.expectation(description: "Getting All Elements")
        sut.getAllElements(display: .allElement) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let elements):
                self.testAllElements = elements
                expectation.fulfill()
            case .failure(let error):
                print(error)
            }
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
        XCTAssertNotNil(testAllElements)
        
    }
    
    func testGetAllDeletedElementsReturnTheElementsArray() {
        let expectation = self.expectation(description: "Getting All deleted Elements")
        sut.getAllElements(display: .deleted) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let elements):
                self.testAllDeletedElements = elements
                expectation.fulfill()
            case .failure(let error):
                print(error)
            }
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
        XCTAssertNotNil(testAllDeletedElements)
        
    }
    
    func testGetAllExistingElementsIsCorrect() {
        let expectation = self.expectation(description: "Getting All Existing Elements")
        sut.getAllElements(display: .existing) { [weak self] result in
            
            guard let self = self else { return }
            switch result {
                
            case .success(let result):
                self.testAllExistingElements = result
                expectation.fulfill()
            case .failure(let error):
                print(error)
            }
            
        }
        waitForExpectations(timeout: 2.0, handler: nil)
        XCTAssertNotNil(testAllExistingElements)
        
    }
    
    func testGetAllNoCatalogueElementsIsCorrect() {
        let expectation = self.expectation(description: "Getting All Elements with noCatalogue option")
        sut.getAllElements(display: .noCatalogue) { [weak self] result in
            
            guard let self = self else { return }
            switch result {
                
            case .success(let result):
                self.testAllNoCatalogueElements = result
                expectation.fulfill()
            case .failure(let error):
                print(error)
            }
            
        }
        waitForExpectations(timeout: 2.0, handler: nil)
        XCTAssertNotNil(testAllNoCatalogueElements)
        
    }
    
    func testDeleteCatalogueIsCorrect() {
        
        let expectation = self.expectation(description: "Deleting Catalogue")
        var searchResult: Bool = false
        if testCatalogueForSave == nil {
            sut.saveCatalogue(catalogueName: "test", catalogueType: CatalogueType.box.rawValue, cataloguePlace: "testRoom", catalogueIsFull: true) { [weak self] result in
                guard let self = self else {return}
                switch result {
                case .success(let catalogue):
                    self.testCatalogueForSave = catalogue
                case .failure(let error):
                    print(error)
                }
                
            }
        }
        
        sut.deleteCatalogue(catalogue: testCatalogueForSave) { [weak self] result in
            guard let self = self else { return }
            switch result {
                
            case .success(_):
                self.testCatalogueForSave = nil
                expectation.fulfill()
            case .failure(let error):
                print(error)
            }
        }
        sut.getAllCatalogue { [weak self] result in
            guard let self = self else { return }
            switch result {
                
            case .success(let catalogues):
                self.testAllCatalogue = catalogues
            case .failure(let error):
                print(error)
            }
        }
        
        for catalogue in testAllCatalogue {
            if catalogue.nameCatalogue == "test" {
                searchResult = true
            } else {
                searchResult = false
            }
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
        XCTAssertFalse(searchResult)
        XCTAssertNil(testCatalogueForSave)
        
    }
    
    func testChangeElementsParentCataloguePropertyIfDeleting() {
        
        let expectation = self.expectation(description: "ChangingElementProperty")
        if testCatalogueForSave == nil {
            sut.saveCatalogue(catalogueName: "test", catalogueType: CatalogueType.box.rawValue, cataloguePlace: "testRoom", catalogueIsFull: false) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let catalogue):
                    self.testCatalogueForSave = catalogue
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        if testElementForSave == nil {
            sut.saveElement(elementType: ElementType.book.rawValue, elementAuthor: "Bas", elementRealiseDate: "9999", elementTitle: "Bar", elementDescription: "Baz", elementParentCatalogue: "test", catalogue: testCatalogueForSave, elementCoverPhoto: nil, elementFirstPagePhoto: nil) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let element):
                    self.testElementForSave = element
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        if testElementForSave != nil && testCatalogueForSave != nil {
            sut.deleteCatalogue(catalogue: testCatalogueForSave) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(_):
                    self.testCatalogueForSave = nil
                    expectation.fulfill()
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
        XCTAssertNil(testElementForSave.catalogue)
        XCTAssertNotEqual(testElementForSave.parentCatalogue, "test")
        
    }
    
    func testChangeCatalogueIsCorrect() {
        
        let expectation = self.expectation(description: "Editing catalogue property")
        if testCatalogueForSave == nil {
            sut.saveCatalogue(catalogueName: "test", catalogueType: CatalogueType.box.rawValue, cataloguePlace: "testRoom", catalogueIsFull: false) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let catalogue):
                    self.testCatalogueForSave = catalogue
                    self.testCatalogueForSave.placeOfCatalogue = "testRoom2"
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            testCatalogueForSave.placeOfCatalogue = "testRoom2"
        }
        
        sut.editCatalogue(catalogue: testCatalogueForSave) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let catalogue):
                self.testCatalogue = catalogue
                expectation.fulfill()
            case .failure(let error):
                print(error)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
        XCTAssertEqual(testCatalogue.placeOfCatalogue, "testRoom2")
        
    }
    
    func testMarkingElementThenItDeleting() {
        let expectation = self.expectation(description: "Marking deleting element")
        if testCatalogueForSave == nil {
            sut.saveCatalogue(catalogueName: "test", catalogueType: CatalogueType.box.rawValue, cataloguePlace: "testRoom", catalogueIsFull: false) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let catalogue):
                    self.testCatalogueForSave = catalogue
                case .failure(let error):
                    print(error)
                }
            }
        }
        if testElementForSave == nil {
            sut.saveElement(elementType: ElementType.book.rawValue, elementAuthor: "Bas", elementRealiseDate: "9999", elementTitle: "Bar", elementDescription: "Baz", elementParentCatalogue: "test", catalogue: testCatalogueForSave, elementCoverPhoto: nil, elementFirstPagePhoto: nil) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let element):
                    self.testElementForSave = element
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        sut.deleteElement(element: testElementForSave) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let res):
                if res == true {
                    self.testElementForSave = nil
                }
            case .failure(let error):
                print(error)
            }
            
        }
        
        sut.getElementsFromCatalogue(catalogue: testCatalogueForSave, display: .deleted) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let elements):
                self.testAllElements = elements
                expectation.fulfill()
            case .failure(let error):
                print(error)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
        XCTAssertNotNil(testAllElements[0])
        XCTAssertTrue(testAllElements[0].isDeletedElement)
        XCTAssertNotEqual(testAllElements[0].elementDescription, "Baz")
        
    }
    
    func testDeletingElement() {
        
        var deletingResult: Bool = false
        let expectation = self.expectation(description: "Deleting element")
        if testElementForSave == nil {
            if testCatalogueForSave == nil {
                sut.saveCatalogue(catalogueName: "test", catalogueType: CatalogueType.box.rawValue, cataloguePlace: "testRoom", catalogueIsFull: false) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let catalogue):
                        self.testCatalogueForSave = catalogue
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            
            sut.saveElement(elementType: ElementType.book.rawValue, elementAuthor: "Bas", elementRealiseDate: "99991", elementTitle: "Bar", elementDescription: "Baz", elementParentCatalogue: "test", catalogue: testCatalogueForSave, elementCoverPhoto: nil, elementFirstPagePhoto: nil) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let element):
                    self.testElementForSave = element
                case .failure(let error):
                    print(error)
                }
            }
            
            sut.markElementAsDeleted(element: testElementForSave) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(_):
                    self.testElementForSave.isDeletedElement = true
                case .failure(let error):
                    print(error)
                }
            }
            
        }
        
        sut.deleteElement(element: testElementForSave) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.testElementForSave = nil
            case .failure(let error):
                print(error)
            }
        }
        
        sut.getElementsFromCatalogue(catalogue: testCatalogueForSave, display: .allElement) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let elements):
                self.testAllElements = elements
                expectation.fulfill()
            case .failure(let error):
                print(error)
                expectation.fulfill()
            }
        }
        
        if testAllElements.count != 0 {
            for element in testAllElements {
                if element.releaseDate == "99991" {
                    deletingResult = false
                }
            }
        } else {
            deletingResult = true
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
        XCTAssertTrue(deletingResult)
        
    }
    
    func testEditElementMethodIsCorrect() {
        let expectation = self.expectation(description: "Editing element property")
        if testElementForSave == nil {
            
            if testCatalogueForSave == nil {
                sut.saveCatalogue(catalogueName: "test", catalogueType: CatalogueType.box.rawValue, cataloguePlace: "testRoom", catalogueIsFull: false) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let catalogue):
                        self.testCatalogueForSave = catalogue
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            
            sut.saveElement(elementType: ElementType.book.rawValue, elementAuthor: "Bas", elementRealiseDate: "9999", elementTitle: "BarBar", elementDescription: "Baz", elementParentCatalogue: "test", catalogue: testCatalogueForSave, elementCoverPhoto: nil, elementFirstPagePhoto: nil) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let element):
                    self.testElementForSave = element
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        testElementForSave.author = "BasBas"
        testElementForSave.type = ElementType.letter.rawValue
        
        sut.editElement(element: testElementForSave) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let element):
                self.testElementForSave = element
            case .failure(let error):
                print(error)
            }
        }
        
        sut.getElementsFromCatalogue(catalogue: testCatalogueForSave, display: .allElement) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let elements):
                self.testAllElements = elements
                expectation.fulfill()
            case .failure(let error):
                print(error)
                expectation.fulfill()
            }
        }
        
        if testAllElements != nil {
            for element in testAllElements {
                if element.title == "BarBar" {
                    testElement = element
                }
            }
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
        XCTAssertNotNil(testElement)
        XCTAssertEqual(testElement.author, "BasBas")
        XCTAssertEqual(testElement.type, ElementType.letter.rawValue)
        
    }
    
    func testElementChangeParentCatalogueIsCorrect() {
        
        let expectation = self.expectation(description: "Changing parent catalogue!")
        var elementChangeCatalogue: Bool = false
        
        if testElementForSave == nil {
            if testCatalogueForSave == nil {
                if testCatalogueForSaveNew == nil {
                    
                    sut.saveCatalogue(catalogueName: "testNew", catalogueType: CatalogueType.bookcase.rawValue, cataloguePlace: "testRoomNew", catalogueIsFull: false) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success(let catalogue):
                            self.testCatalogueForSaveNew = catalogue
                        case .failure(let error):
                            print(error)
                        }
                    }
                    
                }
                
                sut.saveCatalogue(catalogueName: "test", catalogueType: CatalogueType.box.rawValue, cataloguePlace: "testRoom", catalogueIsFull: false) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let catalogue):
                        self.testCatalogueForSave = catalogue
                    case .failure(let error):
                        print(error)
                    }
                }
                
            }
            
            sut.saveElement(elementType: ElementType.book.rawValue, elementAuthor: "Bas", elementRealiseDate: "9999", elementTitle: "BarBar", elementDescription: "Baz", elementParentCatalogue: "test", catalogue: testCatalogueForSave, elementCoverPhoto: nil, elementFirstPagePhoto: nil) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let element):
                    self.testElementForSave = element
                case .failure(let error):
                    print(error)
                }
            }
            
        }
        
        testElementForSave.parentCatalogue = testCatalogueForSaveNew.nameCatalogue
        testElementForSave.catalogue = testCatalogueForSaveNew
        
        sut.editElement(element: testElementForSave) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let element):
                self.testElementForSave = element
            case .failure(let error):
                print(error)
            }
        }
        
        sut.getElementsFromCatalogue(catalogue: testCatalogueForSaveNew, display: .allElement) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let elements):
                self.testAllElements = elements
                expectation.fulfill()
            case .failure(let error):
                print(error)
                expectation.fulfill()
            }
        }
        
        if testAllElements.count != 0 {
            for element in testAllElements {
                if element.parentCatalogue == testCatalogueForSaveNew.nameCatalogue {
                    elementChangeCatalogue = true
                }
            }
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
        XCTAssertTrue(elementChangeCatalogue)
        XCTAssertEqual(testElementForSave.parentCatalogue, "testNew")
        
    }
    
}
