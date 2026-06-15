import Testing

@testable import NotesApp

@MainActor
struct UserPresenterFactoryTest {
    @Test mutating func testIfMethodGetInstanceReturnsInstanceOfUserPresenter()
        async
    {
        let firstInstance = UserPresenterFactory.getInstance()
        let secondInstance = UserPresenterFactory.getInstance()

        #expect(firstInstance === secondInstance)
    }
}
