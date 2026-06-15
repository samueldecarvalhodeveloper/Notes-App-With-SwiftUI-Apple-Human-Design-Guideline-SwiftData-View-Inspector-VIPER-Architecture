import Testing

@testable import NotesApp

@MainActor
struct NoteManipulatingRouterTest {
    @Test func testIfMethodBuildReturnsBuiltView() {
        let view: NoteManipulatingView? = NoteManipulatingRouter.build(
            noteId: NOTE.id, onNoteDeleted: {})

        #expect(view != nil)
    }
}
