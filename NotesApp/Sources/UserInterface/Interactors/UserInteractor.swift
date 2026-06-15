@MainActor
struct UserInteractor {
    private let userRepository: UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    func getUser() async throws -> User {
        let user = try await userRepository.getUser()

        return User.fromModel(model: user)
    }

    func getCreatedUser(username: String) async throws -> User {
        let createdUserFromService = try await userRepository.getCreatedUser(username: username)

        return User.fromModel(model: createdUserFromService)
    }
}
