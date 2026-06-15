import SwiftUI

struct NotesListingView: View {
    @State var notesListingPresenter: NotesListingPresenter
    @State var userPresenter: UserPresenter
    let onNoteItemSelected: (Int) -> Void
    var didAppear: ((Self) throws -> Void)?
    var didUpdate: ((Self) throws -> Void)?

    var body: some View {
        VStack {
            if notesListingPresenter.isListOfNotesLoaded {
                if notesListingPresenter.listOfNotes.isEmpty {
                    NoNotesSection()
                } else {
                    ListOfNotesSection(
                        listOfNotes: $notesListingPresenter.listOfNotes,
                        onNoteItemTaped: onNoteItemSelected)
                }
            } else {
                LoadingSection()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(NEUTRALS_100)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Hi, \(userPresenter.user!.username)!")
                    .foregroundColor(NEUTRALS_900)
            }
            ToolbarItem(placement: .topBarTrailing) {
                if notesListingPresenter.isNoteCreationCurrentlyAble {
                    Button {
                        notesListingPresenter.createNote(onNoteCreated: onNoteItemSelected)
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(PRIMARY_500)
                    }
                }
            }
        }
        .onAppear {
            notesListingPresenter.loadNotes()

            try? didAppear?(self)
        }
        .onChange(of: [
            notesListingPresenter.isNoteCreationCurrentlyAble,
            notesListingPresenter.isListOfNotesLoaded, userPresenter.user?.username.isEmpty,
        ]) {
            try? didUpdate?(self)
        }
    }
}
