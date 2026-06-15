import SwiftUI

@Observable
@MainActor
class NotesListingPresenter {
    @ObservationIgnored
    private let userId: Int
    private let noteInteractor: NoteInteractor
    var listOfNotes: [Note] = []
    var isListOfNotesLoaded = false
    var isNoteCreationCurrentlyAble = true

    init(userId: Int, noteInteractor: NoteInteractor) {
        self.userId = userId
        self.noteInteractor = noteInteractor
    }

    func loadNotes() {
        Task {
            do {
                try await noteInteractor.synchronizeWithNotesFromService(userId: userId)
            } catch {
                isNoteCreationCurrentlyAble = false
            }

            listOfNotes = await noteInteractor.getNotes()

            isListOfNotesLoaded = true
        }
    }

    func createNote(onNoteCreated: @escaping (Int) -> Void) {
        Task {
            do {
                let createdNote = try await noteInteractor.getCreatedNote(
                    title: "", body: "", userId: userId)

                onNoteCreated(createdNote.id)
            } catch {
                isNoteCreationCurrentlyAble = false
            }
        }
    }
}
