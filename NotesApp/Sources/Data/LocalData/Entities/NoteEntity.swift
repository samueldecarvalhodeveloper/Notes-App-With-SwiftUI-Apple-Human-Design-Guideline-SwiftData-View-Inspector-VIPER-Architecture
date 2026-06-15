import SwiftData

@Model
class NoteEntity: @unchecked Sendable {
    var id: Int
    var title: String
    var body: String
    var createdAt: Int
    var updatedAt: Int
    var userId: Int

    init(id: Int, title: String, body: String, createdAt: Int, updatedAt: Int, userId: Int) {
        self.id = id
        self.title = title
        self.body = body
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.userId = userId
    }

    var model: NoteModel {
        return NoteModel(
            id: id, title: title, body: body, createdAt: createdAt, updatedAt: updatedAt,
            userId: userId)
    }
}
