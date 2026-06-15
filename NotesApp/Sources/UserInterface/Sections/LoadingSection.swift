import SwiftUI

@MainActor
struct LoadingSection: View {
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(.circular)
                .tint(NEUTRALS_500)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(NEUTRALS_100)
    }
}
