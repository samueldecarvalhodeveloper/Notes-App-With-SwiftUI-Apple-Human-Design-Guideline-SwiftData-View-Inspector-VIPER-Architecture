import Testing
import ViewInspector

@testable import NotesApp

@MainActor
struct LoadingSectionTest {
    @Test func testIfSectionIsBuilt() throws {
        let section = try LoadingSection().inspect()

        #expect((try? section.find(ViewType.ProgressView.self)) != nil)
    }
}
