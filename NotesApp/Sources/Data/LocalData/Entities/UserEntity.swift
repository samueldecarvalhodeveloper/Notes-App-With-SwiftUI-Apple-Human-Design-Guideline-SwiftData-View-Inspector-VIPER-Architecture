import SwiftData

@Model
class UserEntity: @unchecked Sendable {
    var id: Int
    var username: String

    init(id: Int, username: String) {
        self.id = id
        self.username = username
    }

    var model: UserModel {
        return UserModel(id: self.id, username: self.username)
    }
}
