import SwiftUI

struct NoteEditingSection: View {
    @State private var noteTitle: String
    @State private var noteBody: String
    var isNoteBeingManipulated: Binding<Bool>
    let onNoteTitleChanged: (String) -> Void
    let onNoteBodyChanged: (String) -> Void

    init(
        initialNoteTitle: String, initialNoteBody: String, isNoteBeingManipulated: Binding<Bool>,
        onNoteTitleChanged: @escaping (String) -> Void,
        onNoteBodyChanged: @escaping (String) -> Void
    ) {
        self.noteTitle = initialNoteTitle
        self.noteBody = initialNoteBody
        self.isNoteBeingManipulated = isNoteBeingManipulated
        self.onNoteTitleChanged = onNoteTitleChanged
        self.onNoteBodyChanged = onNoteBodyChanged
    }

    var body: some View {
        VStack(spacing: 8) {
            TextField(
                "",
                text: Binding(
                    get: { noteTitle },
                    set: { updatedValue in
                        noteTitle = updatedValue

                        onNoteTitleChanged(updatedValue)
                    }
                ),
                prompt: Text("username").font(.system(size: 40)).foregroundStyle(NEUTRALS_300)
            )
            .frame(maxWidth: .infinity, maxHeight: 72)
            .padding(.horizontal, 16)
            .disabled(!isNoteBeingManipulated.wrappedValue)
            .lineLimit(1)
            .font(.system(size: 40))
            .lineSpacing(40)
            .foregroundStyle(NEUTRALS_900)
            ZStack(alignment: .topLeading) {
                if noteBody.isEmpty {
                    Text("Body")
                        .padding(EdgeInsets(top: 8, leading: 20, bottom: 0, trailing: 16))
                        .font(.system(size: 16))
                        .lineSpacing(16)
                        .foregroundStyle(NEUTRALS_300)
                }
                TextEditor(
                    text: Binding(
                        get: { noteBody },
                        set: { updatedValue in
                            noteBody = updatedValue

                            onNoteBodyChanged(updatedValue)
                        }
                    )
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.horizontal, 16)
                .disabled(!isNoteBeingManipulated.wrappedValue)
                .font(.system(size: 16))
                .lineSpacing(16)
                .foregroundStyle(NEUTRALS_900)
                .scrollContentBackground(.hidden)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 8)
        .background(NEUTRALS_100)
    }
}
