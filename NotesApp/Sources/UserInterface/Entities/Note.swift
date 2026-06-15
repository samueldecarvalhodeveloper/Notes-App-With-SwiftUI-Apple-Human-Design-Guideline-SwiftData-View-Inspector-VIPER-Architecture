struct Note {
    let id: Int
    var title: String
    var body: String
    let createdAt: Int
    let updatedAt: Int
    let userId: Int

    static func fromModel(model: NoteModel) -> Note {
        return Note(
            id: model.id,
            title: model.title,
            body: model.body,
            createdAt: model.createdAt,
            updatedAt: model.updatedAt,
            userId: model.userId
        )
    }
}
