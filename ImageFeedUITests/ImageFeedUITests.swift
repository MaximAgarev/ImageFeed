import XCTest

class ImageFeedUITests: XCTestCase {
    
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let passwordTestField = webView.descendants(matching: .secureTextField).element
        passwordTestField.tap()
        passwordTestField.typeText("***")
        
        let loginTestField = webView.descendants(matching: .textField).element
        loginTestField.tap()
        loginTestField.typeText("***")
        
        let loginButton = webView.descendants(matching: .button).element
        loginButton.tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
//        var cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
//        sleep(3)
//        cell.swipeUp()
        sleep(3)
//
//        tablesQuery.element.swipeUp()
//        sleep(3)
//        tablesQuery.element.swipeDown()
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.buttons["Inactive"].tap()
        sleep(3)
        cell.buttons["Active"].tap()
        sleep(3)

        cell.tap()
        sleep(3)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        app.buttons.firstMatch.tap()
        cell.swipeUp()
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        XCTAssertTrue(app.staticTexts["Maxim Agarev"].exists)
        
        let logoutButton = app.buttons["LogoutButton"]
        logoutButton.tap()
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
    }
}
