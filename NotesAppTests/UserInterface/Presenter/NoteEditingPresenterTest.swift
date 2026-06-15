import Foundation
import Testing

@testable import NotesApp

@MainActor
struct NoteEditingPresenterTest {
    var noteDataAccessObject: NoteDataAccessObjectAbstraction
    var noteDataGateway: NoteDataGatewayAbstraction
    var noteRepository: NoteRepository
    var noteInteractor: NoteInteractor
    var noteEditingPresenter: NoteEditingPresenter

    init() {
        noteDataGateway = NoteDataGatewayMock()
        noteDataAccessObject = NoteDataAccessObjectMock()
        noteRepository = NoteRepository(
            noteDataAccessObject: noteDataAccessObject,
            noteDataGateway: noteDataGateway)
        noteInteractor = NoteInteractor(noteRepository: noteRepository)

        noteEditingPresenter = NoteEditingPresenter(
            noteId: NOTE_MODEL.id, noteInteractor: noteInteractor)
    }

    @Test mutating func testIfMethodLoadNoteLoadsNoteData() async {
        noteDataAccessObject = NoteDataAccessObjectMock(getNoteImplementation: { _ in
            return NOTE_ENTITY
        })
        noteRepository = NoteRepository(
            noteDataAccessObject: noteDataAccessObject,
            noteDataGateway: noteDataGateway)
        noteInteractor = NoteInteractor(noteRepository: noteRepository)

        noteEditingPresenter = NoteEditingPresenter(
            noteId: NOTE_MODEL.id, noteInteractor: noteInteractor)

        noteEditingPresenter.loadNote()

        await DataQueryingTimeout.waitQueryExecution()

        #expect(noteEditingPresenter.note.id == NOTE_MODEL.id)
        #expect(noteEditingPresenter.note.title == NOTE_MODEL.title)
        #expect(noteEditingPresenter.note.body == NOTE_MODEL.body)
        #expect(noteEditingPresenter.note.createdAt == NOTE_MODEL.createdAt)
        #expect(noteEditingPresenter.note.updatedAt == NOTE_MODEL.updatedAt)
        #expect(noteEditingPresenter.note.userId == NOTE_MODEL.userId)

        #expect(noteEditingPresenter.isNoteLoaded)
    }

    @Test mutating func testIfMethodManipulateNoteTurnsNoteManipulable() {
        noteEditingPresenter.manipulateNote()

        #expect(noteEditingPresenter.isNoteManipulationAble)
    }

    @Test mutating func testIfMethodConcludeNoteUpdatesNoteData() async {
        var isNoteDataUpdated = false

        noteDataGateway = NoteDataGatewayMock(getUpdatedNoteImplementation: { _, _, _ in
            return NOTE_MODEL
        })
        noteDataAccessObject = NoteDataAccessObjectMock(
            getNoteImplementation: { _ in
                return NOTE_ENTITY
            },
            updateNoteImplementation: { _ in
                isNoteDataUpdated = true
            })
        noteRepository = NoteRepository(
            noteDataAccessObject: noteDataAccessObject,
            noteDataGateway: noteDataGateway)
        noteInteractor = NoteInteractor(noteRepository: noteRepository)

        noteEditingPresenter = NoteEditingPresenter(
            noteId: NOTE_MODEL.id, noteInteractor: noteInteractor)

        noteEditingPresenter.loadNote()

        await DataQueryingTimeout.waitQueryExecution()

        noteEditingPresenter.concludeNote()

        await DataQueryingTimeout.waitQueryExecution()

        #expect(noteEditingPresenter.note.id == NOTE_MODEL.id)
        #expect(noteEditingPresenter.note.title == NOTE_MODEL.title)
        #expect(noteEditingPresenter.note.body == NOTE_MODEL.body)
        #expect(noteEditingPresenter.note.createdAt == NOTE_MODEL.createdAt)
        #expect(noteEditingPresenter.note.updatedAt == NOTE_MODEL.updatedAt)
        #expect(noteEditingPresenter.note.userId == NOTE_MODEL.userId)

        #expect(!noteEditingPresenter.isNoteBeingManipulated)

        #expect(isNoteDataUpdated)
    }

    @Test mutating func testIfMethodConcludeNoteTurnsNoteManipulationNotAble() async {
        noteDataGateway = NoteDataGatewayMock(getUpdatedNoteImplementation: { _, _, _ in
            throw TestErrors.testForcedError
        })
        noteDataAccessObject = NoteDataAccessObjectMock(getNoteImplementation: { _ in
            return NOTE_ENTITY
        })
        noteRepository = NoteRepository(
            noteDataAccessObject: noteDataAccessObject,
            noteDataGateway: noteDataGateway)
        noteInteractor = NoteInteractor(noteRepository: noteRepository)

        noteEditingPresenter = NoteEditingPresenter(
            noteId: NOTE_MODEL.id, noteInteractor: noteInteractor)

        noteEditingPresenter.loadNote()

        await DataQueryingTimeout.waitQueryExecution()

        noteEditingPresenter.concludeNote()

        await DataQueryingTimeout.waitQueryExecution()

        #expect(!noteEditingPresenter.isNoteManipulationAble)
        #expect(!noteEditingPresenter.isNoteBeingManipulated)
    }

    @Test mutating func testIfMethodDeleteNoteDeletesNoteData() async {
        var isLocalNoteDataDeleted = false
        var isRemoteNoteDataDeleted = false
        var isNoteDeletionConcluded = false

        noteDataGateway = NoteDataGatewayMock(deleteNoteImplementation: { _, _ in
            isRemoteNoteDataDeleted = true
        })
        noteDataAccessObject = NoteDataAccessObjectMock(
            getNoteImplementation: { _ in
                return NOTE_ENTITY
            },
            deleteNoteImplementation: { _ in
                isLocalNoteDataDeleted = true
            })
        noteRepository = NoteRepository(
            noteDataAccessObject: noteDataAccessObject,
            noteDataGateway: noteDataGateway)
        noteInteractor = NoteInteractor(noteRepository: noteRepository)

        noteEditingPresenter = NoteEditingPresenter(
            noteId: NOTE_MODEL.id, noteInteractor: noteInteractor)

        noteEditingPresenter.loadNote()

        await DataQueryingTimeout.waitQueryExecution()

        noteEditingPresenter.deleteNote { isNoteDeletionConcluded = true }

        await DataQueryingTimeout.waitQueryExecution()

        #expect(isRemoteNoteDataDeleted)
        #expect(isLocalNoteDataDeleted)
        #expect(isNoteDeletionConcluded)
    }

    @Test mutating func testIfMethodDeleteNoteTurnsNoteManipulationNotAble() async {
        noteDataGateway = NoteDataGatewayMock(deleteNoteImplementation: { _, _ in
            throw TestErrors.testForcedError
        })
        noteDataAccessObject = NoteDataAccessObjectMock(getNoteImplementation: { _ in
            return NOTE_ENTITY
        })
        noteRepository = NoteRepository(
            noteDataAccessObject: noteDataAccessObject,
            noteDataGateway: noteDataGateway)
        noteInteractor = NoteInteractor(noteRepository: noteRepository)

        noteEditingPresenter = NoteEditingPresenter(
            noteId: NOTE_MODEL.id, noteInteractor: noteInteractor)

        noteEditingPresenter.loadNote()

        await DataQueryingTimeout.waitQueryExecution()

        noteEditingPresenter.deleteNote {}

        await DataQueryingTimeout.waitQueryExecution()

        #expect(!noteEditingPresenter.isNoteManipulationAble)
        #expect(!noteEditingPresenter.isNoteBeingManipulated)
    }
}
