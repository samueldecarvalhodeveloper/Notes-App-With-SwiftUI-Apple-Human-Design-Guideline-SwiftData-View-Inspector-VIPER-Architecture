import Testing

@testable import NotesApp

@MainActor
struct NoteDataAccessObjectTest {
    var noteDataAccessObject: NoteDataAccessObjectAbstraction

    init() {
        noteDataAccessObject = NoteDataAccessObjectMock()
    }

    @Test mutating func testIfMethodGetNotesReturnsListOfNotesFromDatabase() async {
        noteDataAccessObject = NoteDataAccessObjectMock(getNotesImplementation: {
            return [NOTE_ENTITY]
        })

        let listOfNotesFromDatabase = try! await noteDataAccessObject.getNotes()

        #expect(listOfNotesFromDatabase.first!.id == NOTE_ENTITY.id)
        #expect(listOfNotesFromDatabase.first!.title == NOTE_ENTITY.title)
        #expect(listOfNotesFromDatabase.first!.body == NOTE_ENTITY.body)
        #expect(listOfNotesFromDatabase.first!.createdAt == NOTE_ENTITY.createdAt)
        #expect(listOfNotesFromDatabase.first!.updatedAt == NOTE_ENTITY.updatedAt)
        #expect(listOfNotesFromDatabase.first!.userId == NOTE_ENTITY.userId)
    }

    @Test mutating func testIfMethodGetNoteReturnsNoteFromDatabase() async {
        noteDataAccessObject = NoteDataAccessObjectMock(getNoteImplementation: { _ in
            return NOTE_ENTITY
        })

        let noteFromDatabase = try! await noteDataAccessObject.getNote(noteId: NOTE_ENTITY.id)

        #expect(noteFromDatabase.id == NOTE_ENTITY.id)
        #expect(noteFromDatabase.title == NOTE_ENTITY.title)
        #expect(noteFromDatabase.body == NOTE_ENTITY.body)
        #expect(noteFromDatabase.createdAt == NOTE_ENTITY.createdAt)
        #expect(noteFromDatabase.updatedAt == NOTE_ENTITY.updatedAt)
        #expect(noteFromDatabase.userId == NOTE_ENTITY.userId)
    }

    @Test mutating func testIfMethodCreateNoteCreatesNoteOnDatabase() async {
        var isNoteCreated = false

        noteDataAccessObject = NoteDataAccessObjectMock(createNoteImplementation: { _ in
            isNoteCreated = true
        })

        try! await noteDataAccessObject.createNote(note: NOTE_ENTITY)

        #expect(isNoteCreated)
    }

    @Test mutating func testIfMethodUpdateNoteUpdatesNoteOnDatabase() async {
        var isNoteUpdated = false

        noteDataAccessObject = NoteDataAccessObjectMock(updateNoteImplementation: { _ in
            isNoteUpdated = true
        })

        try! await noteDataAccessObject.updateNote(note: NOTE_ENTITY)

        #expect(isNoteUpdated)
    }

    @Test mutating func testIfMethodDeleteNotesDeletesAllNotesOnDatabase() async {
        var areNotesDeleted = false

        noteDataAccessObject = NoteDataAccessObjectMock(deleteNotesImplementation: {
            areNotesDeleted = true
        })

        try! await noteDataAccessObject.deleteNotes()

        #expect(areNotesDeleted)
    }

    @Test mutating func testIfMethodDeleteNoteDeletesNoteOnDatabase() async {
        var isNoteDeleted = false

        noteDataAccessObject = NoteDataAccessObjectMock(deleteNoteImplementation: { _ in
            isNoteDeleted = true
        })

        try! await noteDataAccessObject.deleteNote(id: NOTE_ENTITY.id)

        #expect(isNoteDeleted)
    }
}
