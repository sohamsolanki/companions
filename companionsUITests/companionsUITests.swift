import XCTest

/// End-to-end checks for the two states the app can launch into.
///
/// Launch state is set two ways. `-hasOnboarded YES -userName Sam` uses the `UserDefaults`
/// argument domain, which wins over anything persisted — good for read-only screens.
/// The onboarding test instead uses `-UITestResetState`, because it needs the app to be
/// able to *write* the values it's exercising.
final class companionsUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    private func launch(arguments: [String]) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments += arguments
        app.launch()
        return app
    }

    @MainActor
    func testOnboardingBlocksContinueUntilNameIsEntered() throws {
        let app = launch(arguments: ["-UITestResetState"])

        let nameField = app.textFields["Enter your name"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 5))

        let continueButton = app.buttons["Continue"]
        XCTAssertFalse(continueButton.isEnabled, "Continue should be disabled with no name")

        nameField.tap()
        nameField.typeText("Sam")
        XCTAssertTrue(continueButton.isEnabled, "Continue should enable once a name is typed")
    }

    @MainActor
    func testHomeShowsGreetingAndNewSessionEntryPoint() throws {
        let app = launch(arguments: ["-hasOnboarded", "YES", "-userName", "Sam"])

        XCTAssertTrue(app.staticTexts["Welcome, Sam!"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["New Session"].exists || app.staticTexts["New Session"].exists)
    }

    @MainActor
    func testOpeningANewSessionShowsTheComposer() throws {
        let app = launch(arguments: ["-hasOnboarded", "YES", "-userName", "Sam"])

        let newSession = app.staticTexts["New Session"]
        XCTAssertTrue(newSession.waitForExistence(timeout: 5))
        newSession.tap()

        XCTAssertTrue(app.textFields["What's on your mind?"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["Send entry"].exists)
    }
}
