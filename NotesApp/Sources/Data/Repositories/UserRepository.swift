@MainActor
struct UserRepository {
    private let userDataAccessObject: UserDataAccessObjectAbstraction
    private let userDataGateway: UserDataGatewayAbstraction

    init(
        userDataAccessObject: UserDataAccessObjectAbstraction,
        userDataGateway: UserDataGatewayAbstraction
    ) {
        self.userDataAccessObject = userDataAccessObject
        self.userDataGateway = userDataGateway
    }

    func getUser() async throws -> UserModel {
        let users = (try! await userDataAccessObject.getUsers())

        guard !users.isEmpty else {
            throw UserErrors.notExistingUserError
        }

        return users.first!.model
    }

    func getCreatedUser(username: String) async throws -> UserModel {
        let userToBeCreated = UserDataTransferObject(username: username)
        let createdUserFromService = try await userDataGateway.getCreatedUser(user: userToBeCreated)

        try! await userDataAccessObject.createdUser(user: createdUserFromService.entity)

        return createdUserFromService
    }
}
