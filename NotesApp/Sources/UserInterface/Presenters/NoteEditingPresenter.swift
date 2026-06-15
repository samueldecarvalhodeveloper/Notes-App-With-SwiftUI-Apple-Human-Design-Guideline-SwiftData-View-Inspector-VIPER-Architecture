import SwiftUI

@Observable
@MainActor
class NoteEditingPresenter {
    @ObservationIgnored
    private let noteId: Int
    private let noteInteractor: NoteInteractor
    var note: Note!
    var isNoteManipulationAble = true
    var isNoteLoaded = false
    var isNoteBeingManipulated = false

    init(noteId: Int, noteInteractor: NoteInteractor) {
        self.noteId = noteId
        self.noteInteractor = noteInteractor
    }

    func loadNote() {
        Task {
            note = await noteInteractor.getNote(id: noteId)

            isNoteLoaded = true
        }
    }

    func manipulateNote() {
        isNoteBeingManipulated = true
    }

    func concludeNote() {
        Task {
            do {
                let updatedNote = try await noteInteractor.getUpdatedNote(
                    id: note.id, title: note.title, body: note.body,
                    userId: note.userId)

                note = updatedNote

                isNoteBeingManipulated = false
            } catch {
                isNoteManipulationAble = false

                isNoteBeingManipulated = false
            }
        }
    }

    func deleteNote(onNoteDeleted: @escaping () -> Void) {
        Task {
            do {
                try await noteInteractor.deletedNote(id: note.id, userId: note.userId)

                onNoteDeleted()
            } catch {
                isNoteManipulationAble = false

                isNoteBeingManipulated = false
            }
        }
    }
}
