import Foundation

struct UserModel: nonisolated Codable {
    let id: Int
    let username: String

    var entity: UserEntity {
        return UserEntity(id: self.id, username: self.username)
    }
}
