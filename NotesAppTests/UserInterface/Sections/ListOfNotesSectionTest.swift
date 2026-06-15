import SwiftUI
import Testing
import ViewInspector

@testable import NotesApp

@MainActor
struct ListOfNotesSectionTest {
    @Test func testIfSectionDispatchesActionOnNoteItemTapped() throws {
        var isNoteItemTapped = false
        let section = try ListOfNotesSection(listOfNotes: Binding.constant([NOTE])) { _ in
            isNoteItemTapped = true
        }.inspect()

        try section.find(
            NoteItem
                .self
        ).vStack().zStack(0).simultaneousGesture(DragGesture.self).callOnEnded(
            value: NOTE_ITEM_TAPPED_GESTURE_VALUE)

        #expect(isNoteItemTapped)
    }
}
