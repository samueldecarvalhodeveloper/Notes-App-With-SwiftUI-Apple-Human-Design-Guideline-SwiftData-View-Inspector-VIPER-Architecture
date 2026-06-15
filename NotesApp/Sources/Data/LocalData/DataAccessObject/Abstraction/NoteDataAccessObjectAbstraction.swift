@MainActor
protocol NoteDataAccessObjectAbstraction {
    func getNotes() async throws -> [NoteEntity]

    func getNote(noteId: Int) async throws -> NoteEntity

    func createNote(note: NoteEntity) async throws

    func updateNote(note: NoteEntity) async throws

    func deleteNotes() async throws

    func deleteNote(id: Int) async throws
}
