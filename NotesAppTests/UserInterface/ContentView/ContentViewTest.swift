import SwiftUI
import Testing
import ViewInspector

@testable import NotesApp

@MainActor
struct ContentViewTest {
    @Test func testIfContentViewIsSet() throws {
        let contentView = try? ContentView().inspect()

        #expect(contentView != nil)
    }
}
