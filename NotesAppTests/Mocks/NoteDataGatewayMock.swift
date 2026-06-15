@testable import NotesApp

struct NoteDataGatewayMock: NoteDataGatewayAbstraction {
    let getNotesImplementation: (Int) async throws -> [NoteModel]
    let getCreatedNoteImplementation: (Int, NoteDataTransferObject) async throws -> NoteModel
    let getUpdatedNoteImplementation:
        (Int, Int, NoteDataTransferObject) async throws ->
            NoteModel
    let deleteNoteImplementation: (Int, Int) async throws -> Void

    init(
        getNotesImplementation: @escaping (Int) async throws -> [NoteModel] = { _ in
            fatalError(NOT_IMPLEMENTED_METHOD_MOCK_ERROR_MESSAGE)
        },
        getCreatedNoteImplementation:
            @escaping (Int, NoteDataTransferObject) async throws -> NoteModel = { _, _ in
                fatalError(NOT_IMPLEMENTED_METHOD_MOCK_ERROR_MESSAGE)
            },
        getUpdatedNoteImplementation:
            @escaping (Int, Int, NoteDataTransferObject) async throws ->
            NoteModel = { _, _, _ in fatalError(NOT_IMPLEMENTED_METHOD_MOCK_ERROR_MESSAGE) },
        deleteNoteImplementation: @escaping (Int, Int) async throws -> Void = { _, _ in
            fatalError(NOT_IMPLEMENTED_METHOD_MOCK_ERROR_MESSAGE)
        }
    ) {
        self.getNotesImplementation = getNotesImplementation
        self.getCreatedNoteImplementation = getCreatedNoteImplementation
        self.getUpdatedNoteImplementation = getUpdatedNoteImplementation
        self.deleteNoteImplementation = deleteNoteImplementation
    }

    func getNotes(userId: Int) async throws -> [NoteModel] {
        return try await self.getNotesImplementation(userId)
    }

    func getCreatedNote(userId: Int, note: NoteDataTransferObject) async throws
        -> NoteModel
    {
        return try await self.getCreatedNoteImplementation(userId, note)
    }

    func getUpdatedNote(userId: Int, noteId: Int, note: NoteDataTransferObject) async throws
        -> NoteModel
    {
        return try await self.getUpdatedNoteImplementation(userId, noteId, note)
    }

    func deleteNote(userId: Int, noteId: Int) async throws {
        try await self.deleteNoteImplementation(userId, noteId)
    }
}
