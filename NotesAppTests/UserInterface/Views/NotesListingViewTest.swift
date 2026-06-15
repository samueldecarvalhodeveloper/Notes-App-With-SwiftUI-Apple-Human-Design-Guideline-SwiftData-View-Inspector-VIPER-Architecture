import SwiftUI
import Testing
import ViewInspector

@testable import NotesApp

@MainActor
struct NotesListingViewTest {
    var noteDataAccessObject: NoteDataAccessObjectAbstraction
    var noteDataGateway: NoteDataGatewayAbstraction
    var noteRepository: NoteRepository
    var noteInteractor: NoteInteractor
    var userDataAccessObject: UserDataAccessObjectAbstraction
    var userDataGateway: UserDataGatewayAbstraction
    var userRepository: UserRepository
    var userInteractor: UserInteractor
    var userPresenter: UserPresenter

    init() {
        noteDataGateway = NoteDataGatewayMock()
        noteDataAccessObject = NoteDataAccessObjectMock()
        noteRepository = NoteRepository(
            noteDataAccessObject: noteDataAccessObject, noteDataGateway: noteDataGateway)
        noteInteractor = NoteInteractor(noteRepository: noteRepository)

        userDataGateway = UserDataGatewayMock()
        userDataAccessObject = UserDataAccessObjectMock(getUsersImplementation: { [USER_ENTITY] })
        userRepository = UserRepository(
            userDataAccessObject: userDataAccessObject, userDataGateway: userDataGateway)
        userInteractor = UserInteractor(userRepository: userRepository)
        userPresenter = UserPresenter(userInteractor: userInteractor)
    }

    @Test mutating func testIfViewShowsGreetingsWithUserUsername() async throws {
        var isUserUsernameShown = false

        noteDataGateway = NoteDataGatewayMock(getNotesImplementation: { _ in
            throw TestErrors.testForcedError
        })
        noteDataAccessObject = NoteDataAccessObjectMock(getNotesImplementation: { [] })
        noteRepository = NoteRepository(
            noteDataAccessObject: noteDataAccessObject, noteDataGateway: noteDataGateway)
        noteInteractor = NoteInteractor(noteRepository: noteRepository)

        let notesListingPresenter = NotesListingPresenter(
            userId: USER.id, noteInteractor: noteInteractor)

        let userPresenter = UserPresenter(userInteractor: userInteractor)

        userPresenter.verifyIfUserExists(onUserCreated: { _ in })

        await DataQueryingTimeout.waitQueryExecution()

        var view = NotesListingView(
            notesListingPresenter: notesListingPresenter, userPresenter: userPresenter
        ) { _ in }

        view.didAppear = { viewToBeInspected in
            isUserUsernameShown = try viewToBeInspected.inspect().find(ViewType.Toolbar.self).item()
                .first!.find(ViewType.Text.self).string().contains(userPresenter.user!.username)
        }

        ViewHosting.host(view: view)

        #expect(isUserUsernameShown)

        ViewHosting.expel()
    }

    @Test mutating func testIfViewCreatesNewNoteIfNoteCreationIsAble() async throws {
        var createdNoteId: Int?

        noteDataGateway = NoteDataGatewayMock(
            getNotesImplementation: { _ in [] },
            getCreatedNoteImplementation: { _, _ in NOTE_MODEL })
        noteDataAccessObject = NoteDataAccessObjectMock(
            getNotesImplementation: { [] }, createNoteImplementation: { _ in },
            deleteNotesImplementation: {})
        noteRepository = NoteRepository(
            noteDataAccessObject: noteDataAccessObject, noteDataGateway: noteDataGateway)
        noteInteractor = NoteInteractor(noteRepository: noteRepository)

        let notesListingPresenter = NotesListingPresenter(
            userId: USER.id, noteInteractor: noteInteractor)

        userPresenter.verifyIfUserExists(onUserCreated: { _ in })

        await DataQueryingTimeout.waitQueryExecution()

        var view = NotesListingView(
            notesListingPresenter: notesListingPresenter, userPresenter: userPresenter
        ) { noteId in
            createdNoteId = noteId
        }

        view.didAppear = { viewToBeInspected in
            try viewToBeInspected.inspect().findAll(ViewType.Toolbar.Item.self)[1].button().tap()
        }

        ViewHosting.host(view: view)

        await DataQueryingTimeout.waitQueryExecution()

        #expect(createdNoteId == NOTE_MODEL.id)

        ViewHosting.expel()
    }

    @Test mutating func testIfViewShowsLoadingIndicatorOnNotesLoading() async throws {
        var loadingIndicatorElement: InspectableView<ViewType.ProgressView>?

        noteDataGateway = NoteDataGatewayMock(getNotesImplementation: { _ in
            throw TestErrors.testForcedError
        })
        noteDataAccessObject = NoteDataAccessObjectMock(getNotesImplementation: { [] })
        noteRepository = NoteRepository(
            noteDataAccessObject: noteDataAccessObject, noteDataGateway: noteDataGateway)
        noteInteractor = NoteInteractor(noteRepository: noteRepository)

        let notesListingPresenter = NotesListingPresenter(
            userId: USER.id, noteInteractor: noteInteractor)

        userPresenter.verifyIfUserExists(onUserCreated: { _ in })

        await DataQueryingTimeout.waitQueryExecution()

        var view = NotesListingView(
            notesListingPresenter: notesListingPresenter, userPresenter: userPresenter
        ) { _ in }

        view.didAppear = { viewToBeInspected in
            loadingIndicatorElement = try viewToBeInspected.inspect().find(
                ViewType.ProgressView.self)
        }

        ViewHosting.host(view: view)

        #expect(loadingIndicatorElement != nil)

        ViewHosting.expel()
    }

    @Test mutating func testIfViewShowsNoNotesLabelIfListOfNotesIsEmpty() async throws {
        var noNotesLabelElement: InspectableView<ViewType.Text>?

        noteDataGateway = NoteDataGatewayMock(getNotesImplementation: { _ in
            throw TestErrors.testForcedError
        })
        noteDataAccessObject = NoteDataAccessObjectMock(getNotesImplementation: { [] })
        noteRepository = NoteRepository(
            noteDataAccessObject: noteDataAccessObject, noteDataGateway: noteDataGateway)
        noteInteractor = NoteInteractor(noteRepository: noteRepository)

        let notesListingPresenter = NotesListingPresenter(
            userId: USER.id, noteInteractor: noteInteractor)

        userPresenter.verifyIfUserExists(onUserCreated: { _ in })

        await DataQueryingTimeout.waitQueryExecution()

        var view = NotesListingView(
            notesListingPresenter: notesListingPresenter, userPresenter: userPresenter
        ) { _ in }

        view.didUpdate = { viewToBeInspected in
            noNotesLabelElement = try viewToBeInspected.inspect().find(text: NO_NOTES_LABEL)
        }

        ViewHosting.host(view: view)

        await DataQueryingTimeout.waitQueryExecution()

        #expect(noNotesLabelElement != nil)

        ViewHosting.expel()
    }

    @Test mutating func testIfViewShowsLoadedListOfNotesItems() async throws {
        var noteItemTitleElement: InspectableView<ViewType.Text>?

        noteDataGateway = NoteDataGatewayMock(getNotesImplementation: { _ in
            throw TestErrors.testForcedError
        })
        noteDataAccessObject = NoteDataAccessObjectMock(getNotesImplementation: { [NOTE_ENTITY] })
        noteRepository = NoteRepository(
            noteDataAccessObject: noteDataAccessObject, noteDataGateway: noteDataGateway)
        noteInteractor = NoteInteractor(noteRepository: noteRepository)

        let notesListingPresenter = NotesListingPresenter(
            userId: USER.id, noteInteractor: noteInteractor)

        userPresenter.verifyIfUserExists(onUserCreated: { _ in })

        await DataQueryingTimeout.waitQueryExecution()

        var view = NotesListingView(
            notesListingPresenter: notesListingPresenter, userPresenter: userPresenter
        ) { _ in }

        view.didUpdate = { viewToBeInspected in
            noteItemTitleElement = try viewToBeInspected.inspect().find(text: NOTE_ENTITY.title)
        }

        ViewHosting.host(view: view)

        await DataQueryingTimeout.waitQueryExecution()

        #expect(noteItemTitleElement != nil)

        ViewHosting.expel()
    }
}
