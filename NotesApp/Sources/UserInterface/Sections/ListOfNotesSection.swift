import SwiftUI

@MainActor
struct ListOfNotesSection: View {
    @Binding var listOfNotes: [Note]
    let onNoteItemTaped: (Int) -> Void

    var body: some View {
        VStack {
            ForEach(listOfNotes, id: \.id) { note in
                NoteItem(note: note, onTap: onNoteItemTaped)
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(NEUTRALS_100)
    }
}
