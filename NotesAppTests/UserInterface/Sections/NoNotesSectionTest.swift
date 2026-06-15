import Testing
import ViewInspector

@testable import NotesApp

@MainActor
struct NoNotesSectionTest {
    @Test func testIfSectionIsBuilt() throws {
        let section = try NoNotesSection().inspect()

        #expect((try? section.find(text: NO_NOTES_LABEL)) != nil)
    }
}
