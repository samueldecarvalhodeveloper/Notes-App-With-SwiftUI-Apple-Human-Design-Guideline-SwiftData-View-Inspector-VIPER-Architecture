@testable import NotesApp

struct UserDataGatewayMock: UserDataGatewayAbstraction {
    let getCreatedUserImplementation: (UserDataTransferObject) async throws -> UserModel

    init(
        getCreatedUserImplementation: @escaping (UserDataTransferObject) async throws -> UserModel =
            { _ in
                fatalError(NOT_IMPLEMENTED_METHOD_MOCK_ERROR_MESSAGE)
            }
    ) {
        self.getCreatedUserImplementation = getCreatedUserImplementation
    }

    func getCreatedUser(user: UserDataTransferObject) async throws -> UserModel {
        try await getCreatedUserImplementation(user)
    }
}
