struct User {
    let id: Int
    let username: String

    static func fromModel(model: UserModel) -> User {
        return User(
            id: model.id,
            username: model.username
        )
    }
}
