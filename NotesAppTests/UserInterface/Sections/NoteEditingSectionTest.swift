import SwiftUI
import Testing
import ViewInspector

@testable import NotesApp

@MainActor
struct NoteEditingSectionSectionTest {
    @Test func testIfSectionDispatchesNoteEditingAction() throws {
        var editedNoteTitle: String = ""
        var editedNoteBody: String = ""
        let section = try NoteEditingSection(
            initialNoteTitle: "",
            initialNoteBody: "",
            isNoteBeingManipulated: Binding.constant(true)
        ) { updatedNoteTitle in
            editedNoteTitle = updatedNoteTitle
        } onNoteBodyChanged: { updatedNoteBody in
            editedNoteBody = updatedNoteBody
        }.inspect()

        try section.find(ViewType.TextField.self).setInput(NOTE.title)

        try section.find(ViewType.TextEditor.self).setInput(NOTE.body)

        #expect(editedNoteTitle == NOTE.title)
        #expect(editedNoteBody == NOTE.body)
    }

    @Test func testIfSectionShowNoteBodyTextInputPlaceholder() throws {
        let section = try NoteEditingSection(
            initialNoteTitle: "",
            initialNoteBody: "",
            isNoteBeingManipulated: Binding.constant(true)
        ) { _ in
        } onNoteBodyChanged: { _ in
        }.inspect()

        #expect((try? section.find(text: NOTE_BODY_TEXT_INPUT_PLACEHOLDER)) != nil)
    }
}
