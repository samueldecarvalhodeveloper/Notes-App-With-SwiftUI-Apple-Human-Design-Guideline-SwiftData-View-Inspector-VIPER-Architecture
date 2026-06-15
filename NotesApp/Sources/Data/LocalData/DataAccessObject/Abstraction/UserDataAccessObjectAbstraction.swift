@MainActor
protocol UserDataAccessObjectAbstraction {
    func getUsers() async throws -> [UserEntity]

    func createdUser(user: UserEntity) async throws
}
