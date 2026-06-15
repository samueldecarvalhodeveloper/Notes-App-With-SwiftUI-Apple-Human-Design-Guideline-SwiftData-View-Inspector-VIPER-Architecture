import Foundation
import Testing

@testable import NotesApp

@MainActor
struct NotesListingPresenterTest {
    var noteDataAccessObject: NoteDataAccessObjectAbstraction
    var noteDataGateway: NoteDataGatewayAbstraction
    var noteRepository: NoteRepository
    var noteInteractor: NoteInteractor
    var notesListingPresenter: NotesListingPresenter

    init() {
        noteDataGateway = NoteDataGatewayMock()
        noteDataAccessObject = NoteDataAccessObjectMock()
        noteRepository = NoteRepository(
            noteDataAccessObject: noteDataAccessObject,
            noteDataGateway: noteDataGateway)
        noteInteractor = NoteInteractor(noteRepository: noteRepository)

        notesListingPresenter = NotesListingPresenter(
            userId: USER.id, noteInteractor: noteInteractor)
    }

    @Test
    mutating func testIfMethodLoadNotesSynchronizesLocalNotesDataWithRemoteDataAndLoadsNotesData()
        async
    {
        var isNoteDeleted = false
        var isNoteCreated = false

        noteDataGateway = NoteDataGatewayMock(getNotesImplementation: { _ in
            return [NOTE_MODEL]
        })
        noteDataAccessObject = NoteDataAccessObjectMock(
            getNotesImplementation: {
                return [NOTE_ENTITY]
            },
            createNoteImplementation: { _ in
                isNoteCreated = true
            },
            deleteNotesImplementation: {
                isNoteDeleted = true
            }
        )
        noteRepository = NoteRepository(
            noteDataAccessObject: noteDataAccessObject,
            noteDataGateway: noteDataGateway
        )
        noteInteractor = NoteInteractor(noteRepository: noteRepository)

        notesListingPresenter = NotesListingPresenter(
            userId: USER.id, noteInteractor: noteInteractor)

        notesListingPresenter.loadNotes()

        await DataQueryingTimeout.waitQueryExecution()

        #expect(notesListingPresenter.listOfNotes.count == 1)

        #expect(notesListingPresenter.isListOfNotesLoaded)

        #expect(isNoteDeleted)
        #expect(isNoteCreated)
    }

    @Test
    mutating func
        testIfMethodLoadNotesTurnsNoteCreationNotAbleIfNotesSynchronizationFailsAndLoadsNotesData()
        async
    {
        noteDataGateway = NoteDataGatewayMock(getNotesImplementation: { _ in
            throw TestErrors.testForcedError
        })
        noteDataAccessObject = NoteDataAccessObjectMock(getNotesImplementation: {
            return [NOTE_ENTITY]
        })
        noteRepository = NoteRepository(
            noteDataAccessObject: noteDataAccessObject,
            noteDataGateway: noteDataGateway
        )
        noteInteractor = NoteInteractor(noteRepository: noteRepository)

        notesListingPresenter = NotesListingPresenter(
            userId: USER.id, noteInteractor: noteInteractor)

        notesListingPresenter.loadNotes()

        await DataQueryingTimeout.waitQueryExecution()

        #expect(notesListingPresenter.listOfNotes.count == 1)

        #expect(!notesListingPresenter.isNoteCreationCurrentlyAble)

        #expect(notesListingPresenter.isListOfNotesLoaded)
    }

    @Test
    mutating func testIfMethodCreateNoteCreatesNoteData()
        async
    {
        var isLocalNoteCreated = false
        var createdNoteId: Int?

        noteDataGateway = NoteDataGatewayMock(getCreatedNoteImplementation: { _, _ in
            return NOTE_MODEL
        })
        noteDataAccessObject = NoteDataAccessObjectMock(createNoteImplementation: { _ in
            isLocalNoteCreated = true
        })
        noteRepository = NoteRepository(
            noteDataAccessObject: noteDataAccessObject,
            noteDataGateway: noteDataGateway
        )
        noteInteractor = NoteInteractor(noteRepository: noteRepository)

        notesListingPresenter = NotesListingPresenter(
            userId: USER.id, noteInteractor: noteInteractor)

        notesListingPresenter.createNote { noteId in
            createdNoteId = noteId
        }

        await DataQueryingTimeout.waitQueryExecution()

        #expect(isLocalNoteCreated)

        #expect(createdNoteId == NOTE.id)
    }

    @Test
    mutating func testIfMethodCreateNoteTurnsNoteCreationNotAbleIfNoteCreationFails()
        async
    {
        noteDataGateway = NoteDataGatewayMock(getCreatedNoteImplementation: { _, _ in
            throw TestErrors.testForcedError
        })
        noteRepository = NoteRepository(
            noteDataAccessObject: noteDataAccessObject,
            noteDataGateway: noteDataGateway
        )
        noteInteractor = NoteInteractor(noteRepository: noteRepository)

        notesListingPresenter = NotesListingPresenter(
            userId: USER.id, noteInteractor: noteInteractor)

        notesListingPresenter.createNote { _ in }

        await DataQueryingTimeout.waitQueryExecution()

        #expect(!notesListingPresenter.isNoteCreationCurrentlyAble)
    }
}
