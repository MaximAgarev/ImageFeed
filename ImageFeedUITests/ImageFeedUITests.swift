import XCTest

class ImageFeedUITests: XCTestCase {
    
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    override func tearDown() {
        app.tabBars.buttons.element(boundBy: 1).tap()

        let logoutButton = app.buttons["LogoutButton"]
        logoutButton.tap()

        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
    }
    
    func testAuth() throws {
        if !app.buttons["Authenticate"].exists {
            tearDown()
            sleep(3)
        }
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        fulfillCredentials(testAuth: true)

        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        sleep(3)

        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        sleep(3)
        if app.buttons["Authenticate"].exists {
            fulfillCredentials(testAuth: false)
        }
        
        let tablesQuery = app.tables
        sleep(3)
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.buttons.firstMatch.tap()
        sleep(3)
        cell.buttons.firstMatch.tap()
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
        if app.buttons["Authenticate"].exists {
            fulfillCredentials(testAuth: false)
        }
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        XCTAssertTrue(app.staticTexts["Maxim Agarev"].exists)
    }
    
    private func fulfillCredentials(testAuth: Bool) {
        if !testAuth {
            app.buttons["Authenticate"].tap()
        }
        let webView = app.webViews["UnsplashWebView"]
        
        let passwordTestField = webView.descendants(matching: .secureTextField).element
        passwordTestField.tap()
        sleep(3)
        let password = "Mm12345678"
        passwordTestField.typeText(password)

        let loginTestField = webView.descendants(matching: .textField).element
        loginTestField.tap()
        sleep(3)
        let login = "maximagarev@yandex.ru"
        loginTestField.typeText(login)

        let loginButton = webView.descendants(matching: .button).element
        loginButton.tap()
        
        sleep(3)
        //Ищем статик "ImageFeed", с которого начинается запрос на авторизацию
        if webView.descendants(matching: .staticText).element(matching: .staticText, identifier: "ImageFeed").exists {
            webView.descendants(matching: .button).element.firstMatch.tap()
        }
    }
    

}
