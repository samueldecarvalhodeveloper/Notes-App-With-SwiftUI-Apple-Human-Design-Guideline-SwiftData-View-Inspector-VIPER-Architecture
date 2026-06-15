@MainActor
struct NoteRepository {
    private let noteDataAccessObject: NoteDataAccessObjectAbstraction
    private let noteDataGateway: NoteDataGatewayAbstraction

    init(
        noteDataAccessObject: NoteDataAccessObjectAbstraction,
        noteDataGateway: NoteDataGatewayAbstraction
    ) {
        self.noteDataAccessObject = noteDataAccessObject
        self.noteDataGateway = noteDataGateway
    }

    func synchronizeWithNotesFromService(userId: Int) async throws {
        let listOfNotesFromService = try await noteDataGateway.getNotes(userId: userId)

        try! await noteDataAccessObject.deleteNotes()

        for note in listOfNotesFromService {
            try! await noteDataAccessObject.createNote(note: note.entity)
        }
    }

    func getNotes() async -> [NoteModel] {
        return (try! await noteDataAccessObject.getNotes()).map({ note in note.model })
    }

    func getNote(id: Int) async -> NoteModel {
        return (try! await noteDataAccessObject.getNote(noteId: id)).model
    }

    func getCreatedNote(title: String, body: String, userId: Int) async throws -> NoteModel {
        let createdNoteFromService =
            try await noteDataGateway.getCreatedNote(
                userId: userId,
                note: NoteDataTransferObject(title: title, body: body)
            )

        try! await noteDataAccessObject.createNote(note: createdNoteFromService.entity)

        return createdNoteFromService
    }

    func getUpdatedNote(id: Int, title: String, body: String, userId: Int) async throws -> NoteModel
    {
        let noteDataTransferObject = NoteDataTransferObject(title: title, body: body)
        let updatedNoteFromService =
            try await noteDataGateway.getUpdatedNote(
                userId: userId,
                noteId: id,
                note: noteDataTransferObject
            )

        try! await noteDataAccessObject.updateNote(note: updatedNoteFromService.entity)

        return updatedNoteFromService
    }

    func deletedNote(id: Int, userId: Int) async throws {
        try await noteDataGateway.deleteNote(userId: userId, noteId: id)

        try! await noteDataAccessObject.deleteNote(id: id)
    }
}
