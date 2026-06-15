import SwiftUI

@MainActor
struct NoteManipulatingView: View {
    @State var noteEditingPresenter: NoteEditingPresenter
    let onNoteDeleted: () -> Void
    var didAppear: ((Self) throws -> Void)?
    var didUpdate: ((Self) throws -> Void)?

    var body: some View {
        VStack {
            if noteEditingPresenter.isNoteLoaded {
                NoteEditingSection(
                    initialNoteTitle: noteEditingPresenter.note.title,
                    initialNoteBody: noteEditingPresenter.note.body,
                    isNoteBeingManipulated: $noteEditingPresenter.isNoteBeingManipulated,
                    onNoteTitleChanged: { updatedTitle in
                        noteEditingPresenter.note.title = updatedTitle
                    },
                    onNoteBodyChanged: { updatedBody in noteEditingPresenter.note.body = updatedBody
                    })
            } else {
                LoadingSection()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(NEUTRALS_100)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if noteEditingPresenter.isNoteManipulationAble && noteEditingPresenter.isNoteLoaded
                {
                    if noteEditingPresenter.isNoteBeingManipulated {
                        Button {
                            noteEditingPresenter.concludeNote()
                        } label: {
                            Image(systemName: "checkmark")
                                .foregroundStyle(PRIMARY_500)
                        }
                    } else {
                        Button {
                            noteEditingPresenter.manipulateNote()
                        } label: {
                            Image(systemName: "pencil")
                                .foregroundStyle(PRIMARY_500)
                        }
                    }
                    Button {
                        noteEditingPresenter.deleteNote {
                            onNoteDeleted()
                        }
                    } label: {
                        Image(systemName: "trash")
                            .foregroundStyle(PRIMARY_500)
                    }
                }
            }
        }
        .onAppear {
            noteEditingPresenter.loadNote()

            try? self.didAppear?(self)
        }
        .onChange(of: [
            noteEditingPresenter.isNoteManipulationAble,
            noteEditingPresenter.isNoteBeingManipulated, noteEditingPresenter.isNoteLoaded,
        ]) {
            try? self.didUpdate?(self)
        }
    }
}
