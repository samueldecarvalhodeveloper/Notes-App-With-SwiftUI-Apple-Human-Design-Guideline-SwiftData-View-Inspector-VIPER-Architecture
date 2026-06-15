@testable import NotesApp

struct NoteDataAccessObjectMock: NoteDataAccessObjectAbstraction {
    let getNotesImplementation: () async throws -> [NoteEntity]
    let getNoteImplementation: (Int) async throws -> NoteEntity
    let createNoteImplementation: (NoteEntity) async throws -> Void
    let updateNoteImplementation: (NoteEntity) async throws -> Void
    let deleteNotesImplementation: () async throws -> Void
    let deleteNoteImplementation: (Int) async throws -> Void

    init(
        getNotesImplementation: @escaping () async throws -> [NoteEntity] = {
            fatalError(NOT_IMPLEMENTED_METHOD_MOCK_ERROR_MESSAGE)
        },
        getNoteImplementation: @escaping (Int) async throws -> NoteEntity = { _ in
            fatalError(NOT_IMPLEMENTED_METHOD_MOCK_ERROR_MESSAGE)
        },
        createNoteImplementation: @escaping (NoteEntity) async throws -> Void = { _ in
            fatalError(NOT_IMPLEMENTED_METHOD_MOCK_ERROR_MESSAGE)
        },
        updateNoteImplementation: @escaping (NoteEntity) async throws -> Void = { _ in
            fatalError(NOT_IMPLEMENTED_METHOD_MOCK_ERROR_MESSAGE)
        },
        deleteNotesImplementation: @escaping () async throws -> Void = {
            fatalError(NOT_IMPLEMENTED_METHOD_MOCK_ERROR_MESSAGE)
        },
        deleteNoteImplementation: @escaping (Int) async throws -> Void = { _ in
            fatalError(NOT_IMPLEMENTED_METHOD_MOCK_ERROR_MESSAGE)
        }
    ) {
        self.getNotesImplementation = getNotesImplementation
        self.getNoteImplementation = getNoteImplementation
        self.createNoteImplementation = createNoteImplementation
        self.updateNoteImplementation = updateNoteImplementation
        self.deleteNotesImplementation = deleteNotesImplementation
        self.deleteNoteImplementation = deleteNoteImplementation
    }

    func getNotes() async throws -> [NoteEntity] {
        return try await self.getNotesImplementation()
    }

    func getNote(noteId: Int) async throws -> NoteEntity {
        return try await self.getNoteImplementation(noteId)
    }

    func createNote(note: NoteEntity) async throws {
        try await self.createNoteImplementation(note)
    }

    func updateNote(note: NoteEntity) async throws {
        try await self.updateNoteImplementation(note)
    }

    func deleteNotes() async throws {
        try await self.deleteNotesImplementation()
    }

    func deleteNote(id: Int) async throws {
        try await self.deleteNoteImplementation(id)
    }
}
