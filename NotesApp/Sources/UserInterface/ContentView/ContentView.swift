import SwiftUI

@MainActor
struct ContentView: View {
    @State private var isNotesListingViewShown = false
    @State private var isNoteManipulatingViewShown = false
    @State private var userId: Int?
    @State private var noteId: Int?
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack {
            UserCreatingRouter.build { userId in
                self.userId = userId

                isNotesListingViewShown = true
            }
            .navigationDestination(isPresented: $isNotesListingViewShown) {
                if userId != nil {
                    NotesListingRouter.build(userId: userId!) { noteId in
                        self.noteId = noteId

                        isNotesListingViewShown = false
                        isNoteManipulatingViewShown = true
                    }
                }

            }
            .navigationDestination(isPresented: $isNoteManipulatingViewShown) {
                if noteId != nil {
                    NoteManipulatingRouter.build(noteId: noteId!) {
                        noteId = nil

                        isNotesListingViewShown = true
                        isNoteManipulatingViewShown = false
                    }
                }
            }
        }
    }
}
