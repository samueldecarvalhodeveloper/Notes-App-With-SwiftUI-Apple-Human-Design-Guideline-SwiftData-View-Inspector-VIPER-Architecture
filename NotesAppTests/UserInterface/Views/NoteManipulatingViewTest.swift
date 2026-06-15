import SwiftUI
import Testing
import ViewInspector

@testable import NotesApp

@MainActor
struct NoteEditingViewTest {
    var noteDataAccessObject: NoteDataAccessObjectAbstraction
    var noteDataGateway: NoteDataGatewayAbstraction
    var noteRepository: NoteRepository
    var noteInteractor: NoteInteractor

    init() {
        noteDataGateway = NoteDataGatewayMock()
        noteDataAccessObject = NoteDataAccessObjectMock()
        noteRepository = NoteRepository(
            noteDataAccessObject: noteDataAccessObject, noteDataGateway: noteDataGateway)
        noteInteractor = NoteInteractor(noteRepository: noteRepository)
    }

    @Test mutating func testIfViewShowsNoToolbarButtonsOnNoteLoading() async throws {
        var amountOfToolbarButtonsShown: Int?

        noteDataAccessObject = NoteDataAccessObjectMock(getNoteImplementation: { _ in NOTE_ENTITY })
        noteRepository = NoteRepository(
            noteDataAccessObject: noteDataAccessObject, noteDataGateway: noteDataGateway)
        noteInteractor = NoteInteractor(noteRepository: noteRepository)

        let noteEditingPresenter = NoteEditingPresenter(
            noteId: NOTE.id, noteInteractor: noteInteractor)

        var view = NoteManipulatingView(noteEditingPresenter: noteEditingPresenter) {}

        view.didAppear = { viewToBeInspected in
            amountOfToolbarButtonsShown = try viewToBeInspected.inspect().find(
                ViewType.Toolbar.ItemGroup.self
            ).findAll(ViewType.Button.self).count
        }

        ViewHosting.host(view: view)

        #expect(amountOfToolbarButtonsShown == 0)

        ViewHosting.expel()
    }

    @Test mutating func testIfViewTurnsNoteManipulable() async throws {
        noteDataAccessObject = NoteDataAccessObjectMock(getNoteImplementation: { _ in NOTE_ENTITY })
        noteRepository = NoteRepository(
            noteDataAccessObject: noteDataAccessObject, noteDataGateway: noteDataGateway)
        noteInteractor = NoteInteractor(noteRepository: noteRepository)

        let noteEditingPresenter = NoteEditingPresenter(
            noteId: NOTE.id, noteInteractor: noteInteractor)

        noteEditingPresenter.loadNote()

        await DataQueryingTimeout.waitQueryExecution()

        var view = NoteManipulatingView(noteEditingPresenter: noteEditingPresenter) {}

        view.didAppear = { viewToBeInspected in
            try viewToBeInspected.inspect().find(ViewType.Toolbar.ItemGroup.self).findAll(
                ViewType.Button.self)[0].tap()
        }

        ViewHosting.host(view: view)

        await DataQueryingTimeout.waitQueryExecution()

        #expect(noteEditingPresenter.isNoteBeingManipulated)

        ViewHosting.expel()
    }

    @Test mutating func testIfViewUpdatesNoteIfNoteIsBeingManipulated() async throws {
        var isNoteUpdated = false

        noteDataGateway = NoteDataGatewayMock(getUpdatedNoteImplementation: { _, _, _ in
            isNoteUpdated = true

            throw TestErrors.testForcedError
        })
        noteDataAccessObject = NoteDataAccessObjectMock(getNoteImplementation: { _ in NOTE_ENTITY })
        noteRepository = NoteRepository(
            noteDataAccessObject: noteDataAccessObject, noteDataGateway: noteDataGateway)
        noteInteractor = NoteInteractor(noteRepository: noteRepository)

        let noteEditingPresenter = NoteEditingPresenter(
            noteId: NOTE.id, noteInteractor: noteInteractor)

        noteEditingPresenter.loadNote()

        await DataQueryingTimeout.waitQueryExecution()

        noteEditingPresenter.manipulateNote()

        var view = NoteManipulatingView(noteEditingPresenter: noteEditingPresenter) {}

        view.didAppear = { viewToBeInspected in
            try viewToBeInspected.inspect().find(ViewType.Toolbar.ItemGroup.self).findAll(
                ViewType.Button.self)[0].tap()
        }

        ViewHosting.host(view: view)

        await DataQueryingTimeout.waitQueryExecution()

        #expect(isNoteUpdated)

        ViewHosting.expel()
    }

    @Test mutating func testIfViewDeletesNote() async throws {
        var isNoteDeleted = false

        noteDataGateway = NoteDataGatewayMock(deleteNoteImplementation: { _, _ in })
        noteDataAccessObject = NoteDataAccessObjectMock(
            getNoteImplementation: { _ in NOTE_ENTITY }, deleteNoteImplementation: { _ in })
        noteRepository = NoteRepository(
            noteDataAccessObject: noteDataAccessObject, noteDataGateway: noteDataGateway)
        noteInteractor = NoteInteractor(noteRepository: noteRepository)

        let noteEditingPresenter = NoteEditingPresenter(
            noteId: NOTE.id, noteInteractor: noteInteractor)

        noteEditingPresenter.loadNote()

        await DataQueryingTimeout.waitQueryExecution()

        var view = NoteManipulatingView(noteEditingPresenter: noteEditingPresenter) {
            isNoteDeleted = true
        }

        view.didAppear = { viewToBeInspected in
            try viewToBeInspected.inspect().find(ViewType.Toolbar.ItemGroup.self).findAll(
                ViewType.Button.self)[1].tap()
        }

        ViewHosting.host(view: view)

        await DataQueryingTimeout.waitQueryExecution()

        #expect(isNoteDeleted)

        ViewHosting.expel()
    }

    @Test mutating func testIfViewShowsLoadingIndicatorOnNoteLoading() async throws {
        var loadingIndicatorElement: InspectableView<ViewType.ProgressView>?

        noteDataAccessObject = NoteDataAccessObjectMock(getNoteImplementation: { _ in NOTE_ENTITY })
        noteRepository = NoteRepository(
            noteDataAccessObject: noteDataAccessObject, noteDataGateway: noteDataGateway)
        noteInteractor = NoteInteractor(noteRepository: noteRepository)

        let noteEditingPresenter = NoteEditingPresenter(
            noteId: NOTE.id, noteInteractor: noteInteractor)

        var view = NoteManipulatingView(noteEditingPresenter: noteEditingPresenter) {}

        view.didAppear = { viewToBeInspected in
            loadingIndicatorElement = try viewToBeInspected.inspect().find(
                ViewType.ProgressView.self)
        }

        ViewHosting.host(view: view)

        #expect(loadingIndicatorElement != nil)

        ViewHosting.expel()
    }

    @Test mutating func testIfViewShowsLoadedNote() async throws {
        var noteTitleTextInputElement: InspectableView<ViewType.TextField>?
        var noteBodyTextInputElement: InspectableView<ViewType.TextEditor>?

        noteDataAccessObject = NoteDataAccessObjectMock(getNoteImplementation: { _ in NOTE_ENTITY })
        noteRepository = NoteRepository(
            noteDataAccessObject: noteDataAccessObject, noteDataGateway: noteDataGateway)
        noteInteractor = NoteInteractor(noteRepository: noteRepository)

        let noteEditingPresenter = NoteEditingPresenter(
            noteId: NOTE.id, noteInteractor: noteInteractor)

        var view = NoteManipulatingView(noteEditingPresenter: noteEditingPresenter) {}

        view.didUpdate = { viewToBeInspected in
            noteTitleTextInputElement = try viewToBeInspected.inspect().find(
                ViewType.TextField.self)
            noteBodyTextInputElement = try viewToBeInspected.inspect().find(
                ViewType.TextEditor.self)
        }

        ViewHosting.host(view: view)

        await DataQueryingTimeout.waitQueryExecution()

        #expect(noteTitleTextInputElement != nil)
        #expect(noteBodyTextInputElement != nil)

        ViewHosting.expel()
    }

    @Test mutating func testIfViewUpdatesNoteData() async throws {
        noteDataAccessObject = NoteDataAccessObjectMock(getNoteImplementation: { _ in NOTE_ENTITY })
        noteRepository = NoteRepository(
            noteDataAccessObject: noteDataAccessObject, noteDataGateway: noteDataGateway)
        noteInteractor = NoteInteractor(noteRepository: noteRepository)

        let noteEditingPresenter = NoteEditingPresenter(
            noteId: NOTE.id, noteInteractor: noteInteractor)

        var view = NoteManipulatingView(noteEditingPresenter: noteEditingPresenter) {}

        noteEditingPresenter.manipulateNote()

        view.didUpdate = { viewToBeInspected in
            try viewToBeInspected.inspect().find(ViewType.TextField.self).setInput("")
            try viewToBeInspected.inspect().find(ViewType.TextEditor.self).setInput("")
        }

        ViewHosting.host(view: view)

        await DataQueryingTimeout.waitQueryExecution()

        #expect(noteEditingPresenter.note.title == "")
        #expect(noteEditingPresenter.note.body == "")

        ViewHosting.expel()
    }
}
