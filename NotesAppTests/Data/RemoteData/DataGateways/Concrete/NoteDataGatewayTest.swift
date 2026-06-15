import Testing

@testable import NotesApp

@MainActor
struct NoteDataGatewayTest {
    var noteDataGateway: NoteDataGatewayAbstraction

    init() {
        noteDataGateway = NoteDataGatewayMock()
    }

    @Test mutating func testIfMethodGetNotesReturnsListOfNotesFromService() async {
        noteDataGateway = NoteDataGatewayMock(getNotesImplementation: { _ in
            return [NOTE_MODEL]
        })

        let listOfNotesFromService = try! await noteDataGateway.getNotes(userId: USER.id)

        #expect(listOfNotesFromService.first!.id == NOTE_MODEL.id)
        #expect(listOfNotesFromService.first!.title == NOTE_MODEL.title)
        #expect(listOfNotesFromService.first!.body == NOTE_MODEL.body)
        #expect(listOfNotesFromService.first!.createdAt == NOTE_MODEL.createdAt)
        #expect(listOfNotesFromService.first!.updatedAt == NOTE_MODEL.updatedAt)
        #expect(listOfNotesFromService.first!.userId == NOTE_MODEL.userId)
    }

    @Test mutating func testIfMethodGetCreatedNoteReturnsCreatedNoteFromService() async {
        noteDataGateway = NoteDataGatewayMock(getCreatedNoteImplementation: { _, _ in
            return NOTE_MODEL
        })

        let createdNoteFromService = try! await noteDataGateway.getCreatedNote(
            userId: USER.id, note: NOTE_DATA_TRANSFER_OBJECT)

        #expect(createdNoteFromService.id == NOTE_MODEL.id)
        #expect(createdNoteFromService.title == NOTE_MODEL.title)
        #expect(createdNoteFromService.body == NOTE_MODEL.body)
        #expect(createdNoteFromService.createdAt == NOTE_MODEL.createdAt)
        #expect(createdNoteFromService.updatedAt == NOTE_MODEL.updatedAt)
        #expect(createdNoteFromService.userId == NOTE_MODEL.userId)
    }

    @Test mutating func testIfMethodGetUpdatedNoteReturnsUpdatedNoteFromService() async {
        noteDataGateway = NoteDataGatewayMock(getUpdatedNoteImplementation: { _, _, _ in
            return NOTE_MODEL
        })

        let updatedNoteFromService = try! await noteDataGateway.getUpdatedNote(
            userId: USER.id, noteId: NOTE_MODEL.id, note: NOTE_DATA_TRANSFER_OBJECT)

        #expect(updatedNoteFromService.id == NOTE_MODEL.id)
        #expect(updatedNoteFromService.title == NOTE_MODEL.title)
        #expect(updatedNoteFromService.body == NOTE_MODEL.body)
        #expect(updatedNoteFromService.createdAt == NOTE_MODEL.createdAt)
        #expect(updatedNoteFromService.updatedAt == NOTE_MODEL.updatedAt)
        #expect(updatedNoteFromService.userId == NOTE_MODEL.userId)
    }

    @Test mutating func testIfMethodDeleteNoteDeletesNoteOnService() async {
        var isNoteDeleted = false

        noteDataGateway = NoteDataGatewayMock(deleteNoteImplementation: { _, _ in
            isNoteDeleted = true
        })

        try! await noteDataGateway.deleteNote(userId: USER.id, noteId: NOTE_MODEL.id)

        #expect(isNoteDeleted)
    }
}
