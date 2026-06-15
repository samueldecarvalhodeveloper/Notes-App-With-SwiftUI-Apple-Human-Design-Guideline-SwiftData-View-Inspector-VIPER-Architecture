import Testing

@testable import NotesApp

@MainActor
struct NoteInteractorTest {
    var noteDataAccessObject: NoteDataAccessObjectAbstraction
    var noteDataGateway: NoteDataGatewayAbstraction
    var noteRepository: NoteRepository
    var noteInteractor: NoteInteractor

    init() {
        noteDataGateway = NoteDataGatewayMock()
        noteDataAccessObject = NoteDataAccessObjectMock()
        noteRepository = NoteRepository(
            noteDataAccessObject: noteDataAccessObject,
            noteDataGateway: noteDataGateway)

        noteInteractor = NoteInteractor(noteRepository: noteRepository)
    }

    @Test mutating func testIfMethodGetNotesReturnsListOfNotes() async {
        noteDataAccessObject = NoteDataAccessObjectMock(getNotesImplementation: {
            return [NOTE_ENTITY]
        })
        noteRepository = NoteRepository(
            noteDataAccessObject: noteDataAccessObject,
            noteDataGateway: noteDataGateway)

        noteInteractor = NoteInteractor(noteRepository: noteRepository)

        let notes = await noteInteractor.getNotes()

        #expect(notes.first!.id == NOTE_MODEL.id)
        #expect(notes.first!.title == NOTE_MODEL.title)
        #expect(notes.first!.body == NOTE_MODEL.body)
        #expect(notes.first!.createdAt == NOTE_MODEL.createdAt)
        #expect(notes.first!.updatedAt == NOTE_MODEL.updatedAt)
        #expect(notes.first!.userId == NOTE_MODEL.userId)
    }

    @Test mutating func testIfMethodGetNoteReturnsNote() async {
        noteDataAccessObject = NoteDataAccessObjectMock(getNoteImplementation: { _ in
            return NOTE_ENTITY
        })
        noteRepository = NoteRepository(
            noteDataAccessObject: noteDataAccessObject,
            noteDataGateway: noteDataGateway)

        noteInteractor = NoteInteractor(noteRepository: noteRepository)

        let note = await noteInteractor.getNote(id: NOTE_ENTITY.id)

        #expect(note.id == NOTE_MODEL.id)
        #expect(note.title == NOTE_MODEL.title)
        #expect(note.body == NOTE_MODEL.body)
        #expect(note.createdAt == NOTE_MODEL.createdAt)
        #expect(note.updatedAt == NOTE_MODEL.updatedAt)
        #expect(note.userId == NOTE_MODEL.userId)
    }

    @Test mutating func testIfMethodSynchronizeWithNotesFromServiceCallsRepository() async {
        var isNoteDeleted = false
        var isNoteCreated = false

        noteDataGateway = NoteDataGatewayMock(getNotesImplementation: { _ in
            return [NOTE_MODEL]
        })
        noteDataAccessObject = NoteDataAccessObjectMock(
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

        try! await noteRepository.synchronizeWithNotesFromService(userId: USER.id)

        #expect(isNoteCreated)
        #expect(isNoteDeleted)
    }

    @Test mutating func testIfMethodGetCreatedNoteReturnsCreatedNote() async {
        noteDataGateway = NoteDataGatewayMock(getCreatedNoteImplementation: { _, _ in
            return NOTE_MODEL
        })
        noteDataAccessObject = NoteDataAccessObjectMock(createNoteImplementation: { _ in })

        noteRepository = NoteRepository(
            noteDataAccessObject: noteDataAccessObject,
            noteDataGateway: noteDataGateway)

        noteInteractor = NoteInteractor(noteRepository: noteRepository)

        let createdNote = try! await noteInteractor.getCreatedNote(
            title: NOTE_MODEL.title,
            body: NOTE_MODEL.body,
            userId: NOTE_MODEL.userId
        )

        #expect(createdNote.id == NOTE_MODEL.id)
        #expect(createdNote.title == NOTE_MODEL.title)
        #expect(createdNote.body == NOTE_MODEL.body)
        #expect(createdNote.createdAt == NOTE_MODEL.createdAt)
        #expect(createdNote.updatedAt == NOTE_MODEL.updatedAt)
        #expect(createdNote.userId == NOTE_MODEL.userId)
    }

    @Test mutating func testIfMethodGetUpdatedNoteReturnsUpdatedNote() async {
        noteDataGateway = NoteDataGatewayMock(getUpdatedNoteImplementation: { _, _, _ in
            return NOTE_MODEL
        })
        noteDataAccessObject = NoteDataAccessObjectMock(updateNoteImplementation: { _ in })

        noteRepository = NoteRepository(
            noteDataAccessObject: noteDataAccessObject,
            noteDataGateway: noteDataGateway)

        noteInteractor = NoteInteractor(noteRepository: noteRepository)

        let updatedNote = try! await noteInteractor.getUpdatedNote(
            id: NOTE_MODEL.id,
            title: NOTE_MODEL.title,
            body: NOTE_MODEL.body,
            userId: NOTE_MODEL.userId
        )

        #expect(updatedNote.id == NOTE_MODEL.id)
        #expect(updatedNote.title == NOTE_MODEL.title)
        #expect(updatedNote.body == NOTE_MODEL.body)
        #expect(updatedNote.createdAt == NOTE_MODEL.createdAt)
        #expect(updatedNote.updatedAt == NOTE_MODEL.updatedAt)
        #expect(updatedNote.userId == NOTE_MODEL.userId)
    }

    @Test mutating func testIfMethodDeletedNoteDeletesNote() async {
        var isNoteDeleted = false

        noteDataGateway = NoteDataGatewayMock(deleteNoteImplementation: { _, _ in })
        noteDataAccessObject = NoteDataAccessObjectMock(deleteNoteImplementation: { _ in
            isNoteDeleted = true
        })

        noteRepository = NoteRepository(
            noteDataAccessObject: noteDataAccessObject,
            noteDataGateway: noteDataGateway)

        noteInteractor = NoteInteractor(noteRepository: noteRepository)

        try! await noteInteractor.deletedNote(id: NOTE_MODEL.id, userId: USER.id)

        #expect(isNoteDeleted)
    }
}
