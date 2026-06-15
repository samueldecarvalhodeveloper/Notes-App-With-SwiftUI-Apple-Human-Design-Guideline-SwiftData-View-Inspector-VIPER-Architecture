@MainActor
protocol NoteDataGatewayAbstraction {
    func getNotes(userId: Int) async throws -> [NoteModel]

    func getCreatedNote(
        userId: Int,
        note: NoteDataTransferObject,
    ) async throws -> NoteModel

    func getUpdatedNote(
        userId: Int,
        noteId: Int,
        note: NoteDataTransferObject,
    ) async throws -> NoteModel

    func deleteNote(userId: Int, noteId: Int) async throws

}
