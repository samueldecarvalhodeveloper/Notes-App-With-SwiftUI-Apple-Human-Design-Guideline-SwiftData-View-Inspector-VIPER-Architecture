import SwiftUI
import Testing
import ViewInspector

@testable import NotesApp

@MainActor
struct NoteItemTest {
    @Test func testIfComponentDispatchesItsAction() throws {
        var isItemTapped = false
        var tappedNoteId: Int?
        let component = try NoteItem(
            note: NOTE,
            onTap: { noteId in
                isItemTapped = true

                tappedNoteId = noteId
            }
        ).inspect()

        try component.vStack().zStack(0).simultaneousGesture(DragGesture.self).callOnEnded(
            value: NOTE_ITEM_TAPPED_GESTURE_VALUE)

        #expect(isItemTapped)

        #expect(tappedNoteId == NOTE.id)
    }
}
