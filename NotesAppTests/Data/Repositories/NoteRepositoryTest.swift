import Testing

@testable import NotesApp

@MainActor
struct NoteRepositoryTest {
    var noteDataAccessObject: NoteDataAccessObjectAbstraction
    var noteDataGateway: NoteDataGatewayAbstraction
    var noteRepository: NoteRepository

    init() {
        noteDataGateway = NoteDataGatewayMock()
        noteDataAccessObject = NoteDataAccessObjectMock()

        noteRepository = NoteRepository(
            noteDataAccessObject: noteDataAccessObject,
            noteDataGateway: noteDataGateway
        )
    }

    @Test
    mutating func
        testIfMethodSynchronizeWithNotesFromServiceSynchronizesNotesFromServiceToDatabase()
        async
    {
        var isDeleteNotesCalled = false
        var isCreateNoteCalled = false

        noteDataGateway = NoteDataGatewayMock(getNotesImplementation: { _ in
            return [NOTE_MODEL]
        })
        noteDataAccessObject = NoteDataAccessObjectMock(
            createNoteImplementation: { _ in
                isCreateNoteCalled = true
            },
            deleteNotesImplementation: {
                isDeleteNotesCalled = true
            }
        )

        noteRepository = NoteRepository(
            noteDataAccessObject: noteDataAccessObject,
            noteDataGateway: noteDataGateway
        )

        try! await noteRepository.synchronizeWithNotesFromService(userId: USER.id)

        #expect(isDeleteNotesCalled)
        #expect(isCreateNoteCalled)
    }

    @Test mutating func testIfMethodGetNotesReturnsListOfNotesFromDatabase() async {
        noteDataAccessObject = NoteDataAccessObjectMock(getNotesImplementation: {
            return [NOTE_ENTITY]
        })

        noteRepository = NoteRepository(
            noteDataAccessObject: noteDataAccessObject,
            noteDataGateway: noteDataGateway
        )

        let notesFromDatabase = await noteRepository.getNotes()

        #expect(notesFromDatabase.first!.id == NOTE_MODEL.id)
        #expect(notesFromDatabase.first!.title == NOTE_MODEL.title)
        #expect(notesFromDatabase.first!.body == NOTE_MODEL.body)
        #expect(notesFromDatabase.first!.createdAt == NOTE_MODEL.createdAt)
        #expect(notesFromDatabase.first!.updatedAt == NOTE_MODEL.updatedAt)
        #expect(notesFromDatabase.first!.userId == NOTE_MODEL.userId)
    }

    @Test mutating func testIfMethodGetNoteReturnsNoteFromDatabase() async {
        noteDataAccessObject = NoteDataAccessObjectMock(getNoteImplementation: { _ in
            return NOTE_ENTITY
        })

        noteRepository = NoteRepository(
            noteDataAccessObject: noteDataAccessObject,
            noteDataGateway: noteDataGateway
        )

        let noteFromDatabase = await noteRepository.getNote(id: NOTE_ENTITY.id)

        #expect(noteFromDatabase.id == NOTE_MODEL.id)
        #expect(noteFromDatabase.title == NOTE_MODEL.title)
        #expect(noteFromDatabase.body == NOTE_MODEL.body)
        #expect(noteFromDatabase.createdAt == NOTE_MODEL.createdAt)
        #expect(noteFromDatabase.updatedAt == NOTE_MODEL.updatedAt)
        #expect(noteFromDatabase.userId == NOTE_MODEL.userId)
    }

    @Test mutating func testIfMethodGetCreatedNoteReturnsCreatedNoteFromServiceAndStoresOnDatabase()
        async
    {
        var isNoteCreated = false

        noteDataGateway = NoteDataGatewayMock(getCreatedNoteImplementation: { _, _ in
            return NOTE_MODEL
        })
        noteDataAccessObject = NoteDataAccessObjectMock(createNoteImplementation: { _ in
            isNoteCreated = true
        })

        noteRepository = NoteRepository(
            noteDataAccessObject: noteDataAccessObject,
            noteDataGateway: noteDataGateway
        )

        let createdNote = try! await noteRepository.getCreatedNote(
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
        #expect(isNoteCreated)
    }

    @Test
    mutating func testIfMethodGetUpdatedNoteReturnsUpdatedNoteFromServiceAndUpdatesOnDatabase()
        async
    {
        var isNoteUpdated = false

        noteDataGateway = NoteDataGatewayMock(getUpdatedNoteImplementation: { _, _, _ in
            return NOTE_MODEL
        })
        noteDataAccessObject = NoteDataAccessObjectMock(updateNoteImplementation: { _ in
            isNoteUpdated = true
        })

        noteRepository = NoteRepository(
            noteDataAccessObject: noteDataAccessObject,
            noteDataGateway: noteDataGateway
        )

        let updatedNote = try! await noteRepository.getUpdatedNote(
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
        #expect(isNoteUpdated)
    }

    @Test mutating func testIfMethodDeletedNoteDeletesNoteOnDatabaseAndService() async {
        var isDeletedOnService = false
        var isDeletedOnDatabase = false

        noteDataGateway = NoteDataGatewayMock(deleteNoteImplementation: { _, _ in
            isDeletedOnService = true
        })
        noteDataAccessObject = NoteDataAccessObjectMock(deleteNoteImplementation: { _ in
            isDeletedOnDatabase = true
        })

        noteRepository = NoteRepository(
            noteDataAccessObject: noteDataAccessObject,
            noteDataGateway: noteDataGateway
        )

        try! await noteRepository.deletedNote(id: NOTE_MODEL.id, userId: USER.id)

        #expect(isDeletedOnService)
        #expect(isDeletedOnDatabase)
    }
}
