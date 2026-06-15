import Testing

@testable import NotesApp

@MainActor
struct NotesListingRouterTest {
    @Test func testIfMethodBuildReturnsBuiltView() {
        let view: NotesListingView? = NotesListingRouter.build(
            userId: USER.id, onNoteItemSelected: { _ in })

        #expect(view != nil)
    }
}
