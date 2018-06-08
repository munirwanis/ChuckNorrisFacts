//
//  ChuckNorrisFactsUITests.swift
//  ChuckNorrisFactsUITests
//
//  Created by Munir Wanis on 18/05/18.
//  Copyright © 2018 Wanis. All rights reserved.
//

import XCTest
import Swifter
import Nimble


class ChuckNorrisFactsUITests: XCTestCase {
    
    private var app: XCUIApplication!
    private let stubs = HTTPDynamicStubs()
    private let existsPredicate = NSPredicate(format: "exists == true")
    
    override func setUp() {
        super.setUp()
        
        stubs.setUp()
        
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["TEST-MODE"]
        app.launch()
    }
    
    override func tearDown() {
        stubs.tearDown()
        super.tearDown()
    }
    
    func testInitialViewElementsExistence() {
        let searchButton = app.navigationBars["Chuck Norris Facts"].buttons["Pesquisar"]
        searchButton.tap()
        let alert = app.alerts["Pesquisa"]
        let textField = alert.collectionViews.textFields["Digite o termo a ser pesquisado..."]
        let alertButton = alert.buttons["Pesquisar"]
        
        assertExists([searchButton, alert, textField, alertButton])
    }
    
    func testInitialView() {
        assertCellExistence(name: "Antes mesmo de procurar, Chuck Norris já aparece nos resultados!")
    }
    
    func testCorrectSearch() {
        stubs.setupStub(url: "/jokes/search?query=correct", filename: "json_correct")
        performSearch(term: "correct", cellText: "The Death Star's original name was Space Station Chuck Norris.")
    }
    
    func testErrorSearch() {
        stubs.setupStub(url: "/jokes/search?query=wrong", filename: "json_wrong")
        performSearch(term: "wrong", cellText: "Você fez algo de errado porque Chuck Norris nunca erra.")
    }
    
    func testEmptySearch() {
        stubs.setupStub(url: "/jokes/search?query=empty", filename: "json_empty")
        performSearch(term: "empty", cellText: "A busca não encontrou Chuck Norris porque ele só aparece quando quer.")
    }
    
    private func performSearch(term: String, cellText: String) {
        let searchButton = app.navigationBars["Chuck Norris Facts"].buttons["Pesquisar"]
        searchButton.tap()
        
        let alert = app.alerts["Pesquisa"]
        alert.collectionViews.textFields["Digite o termo a ser pesquisado..."].typeText(term)
        alert.buttons["Pesquisar"].tap()
        
        assertCellExistence(name: cellText)
    }
    
    private func assertCellExistence(name cellText: String) {
        let table = app.tables.element
        
        expectation(for: existsPredicate, evaluatedWith: table, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        let cell = table.cells.staticTexts[cellText]
        
        expectation(for: existsPredicate, evaluatedWith: cell, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        cell.swipeUp()
        cell.swipeDown()
    }
    
    private func assertExists(_ elements: [XCUIElement]) {
        elements.forEach { element in
            expect(element.exists).to(beTrue())
        }
    }
}
