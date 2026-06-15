@MainActor
struct NoteInteractor {
    private let noteRepository: NoteRepository

    init(noteRepository: NoteRepository) {
        self.noteRepository = noteRepository
    }

    func synchronizeWithNotesFromService(userId: Int) async throws {
        try await noteRepository.synchronizeWithNotesFromService(userId: userId)
    }

    func getNotes() async -> [Note] {
        return await noteRepository.getNotes().map({ note in Note.fromModel(model: note) })
    }

    func getNote(id: Int) async -> Note {
        let note = await noteRepository.getNote(id: id)

        return Note.fromModel(model: note)
    }

    func getCreatedNote(title: String, body: String, userId: Int) async throws -> Note {
        let createdNoteFromService = try await noteRepository.getCreatedNote(
            title: title,
            body: body,
            userId: userId
        )

        return Note.fromModel(model: createdNoteFromService)
    }

    func getUpdatedNote(id: Int, title: String, body: String, userId: Int) async throws -> Note {
        let updatedNoteFromService = try await noteRepository.getUpdatedNote(
            id: id, title: title, body: body, userId: userId
        )

        return Note.fromModel(model: updatedNoteFromService)
    }

    func deletedNote(id: Int, userId: Int) async throws {
        try await noteRepository.deletedNote(id: id, userId: userId)
    }
}
