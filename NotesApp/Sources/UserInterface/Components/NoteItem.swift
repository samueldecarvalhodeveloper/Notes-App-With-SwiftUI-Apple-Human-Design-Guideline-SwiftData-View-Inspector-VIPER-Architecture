import SwiftUI

@MainActor
struct NoteItem: View {
    @State private var isTouchIndicatorShown = false
    let note: Note
    let onTap: (Int) -> Void

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                VStack(alignment: .leading) {
                    Text(note.title)
                        .font(.system(size: 16, weight: .regular))
                        .kerning(0.25)
                        .foregroundColor(NEUTRALS_900)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(64)
                        .lineLimit(1)
                    Text(note.body)
                        .font(.system(size: 14, weight: .regular))
                        .kerning(0.25)
                        .foregroundColor(NEUTRALS_500)
                        .lineSpacing(64)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity, maxHeight: 78, alignment: .topLeading)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                NEUTRALS_900
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .opacity(isTouchIndicatorShown ? 0.15 : 0)
                    .animation(.easeInOut, value: isTouchIndicatorShown)
            }
            .frame(maxHeight: 78, alignment: .topLeading)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        isTouchIndicatorShown = true
                    }
                    .onEnded { _ in
                        isTouchIndicatorShown = false

                        onTap(note.id)
                    }
            )
            Divider().background(NEUTRALS_500)
        }
    }
}
