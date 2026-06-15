import Foundation

struct NoteModel: nonisolated Codable {
    let id: Int
    let title: String
    let body: String
    let createdAt: Int
    let updatedAt: Int
    let userId: Int

    var entity: NoteEntity {
        NoteEntity(
            id: id, title: title, body: body, createdAt: createdAt, updatedAt: updatedAt,
            userId: userId)
    }
}
