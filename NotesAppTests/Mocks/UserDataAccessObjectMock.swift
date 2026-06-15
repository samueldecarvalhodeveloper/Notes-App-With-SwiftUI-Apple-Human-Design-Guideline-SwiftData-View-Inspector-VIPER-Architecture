@testable import NotesApp

struct UserDataAccessObjectMock: UserDataAccessObjectAbstraction {
    let getUsersImplementation: () async throws -> [UserEntity]
    let createUserImplementation: (UserEntity) async throws -> Void

    init(
        getUsersImplementation: @escaping () async throws -> [UserEntity] = {
            fatalError(NOT_IMPLEMENTED_METHOD_MOCK_ERROR_MESSAGE)
        },
        createUserImplementation: @escaping (UserEntity) async throws -> Void = { _ in
            fatalError(NOT_IMPLEMENTED_METHOD_MOCK_ERROR_MESSAGE)
        }
    ) {
        self.getUsersImplementation = getUsersImplementation
        self.createUserImplementation = createUserImplementation
    }

    func getUsers() async throws -> [UserEntity] {
        return try await self.getUsersImplementation()
    }

    func createdUser(user: UserEntity) async throws {
        try await self.createUserImplementation(user)
    }
}
