import SwiftUI

@MainActor
struct NoNotesSection: View {
    var body: some View {
        VStack {
            Text("No notes")
                .foregroundColor(NEUTRALS_400)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(NEUTRALS_100)
    }
}
