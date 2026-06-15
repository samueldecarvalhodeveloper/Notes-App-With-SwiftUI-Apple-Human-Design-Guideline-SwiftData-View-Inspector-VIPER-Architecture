@preconcurrency import Alamofire

struct NoteDataGateway: NoteDataGatewayAbstraction {
    private let httpClientImplementation: Session

    init(httpClientImplementation: Session) {
        self.httpClientImplementation = httpClientImplementation
    }

    func getNotes(userId: Int) async throws -> [NoteModel] {
        return try await httpClientImplementation.request(
            "\(SERVICE_URL)\(NOTE_BASE_ROUTE)\(userId)/", method: .get
        )
        .validate()
        .serializingDecodable([NoteModel].self)
        .value

    }

    func getCreatedNote(
        userId: Int,
        note: NoteDataTransferObject,
    ) async throws -> NoteModel {
        return try await httpClientImplementation.request(
            "\(SERVICE_URL)\(NOTE_BASE_ROUTE)\(userId)/", method: .post, parameters: note
        )
        .validate()
        .serializingDecodable(NoteModel.self)
        .value
    }

    func getUpdatedNote(
        userId: Int,
        noteId: Int,
        note: NoteDataTransferObject,
    ) async throws -> NoteModel {
        return try await httpClientImplementation.request(
            "\(SERVICE_URL)\(NOTE_BASE_ROUTE)\(userId)/\(noteId)/", method: .patch, parameters: note
        )
        .validate()
        .serializingDecodable(NoteModel.self)
        .value
    }

    func deleteNote(userId: Int, noteId: Int) async throws {
        let _ = try await httpClientImplementation.request(
            "\(SERVICE_URL)\(NOTE_BASE_ROUTE)\(userId)/\(noteId)/", method: .delete
        )
        .validate()
        .serializingDecodable(NoteModel.self)
        .value
    }
}
