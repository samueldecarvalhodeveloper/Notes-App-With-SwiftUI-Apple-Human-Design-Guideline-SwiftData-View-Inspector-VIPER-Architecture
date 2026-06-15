import Testing

@testable import NotesApp

@MainActor
struct UserCreatingRouterTest {
    @Test func testIfMethodBuildReturnsBuiltView() {
        let view: UserCreatingView? = UserCreatingRouter.build(onUserExisting: { _ in })

        #expect(view != nil)
    }
}
