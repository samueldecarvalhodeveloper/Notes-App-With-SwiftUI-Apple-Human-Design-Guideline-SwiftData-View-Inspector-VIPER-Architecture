import Testing

@testable import NotesApp

@MainActor
struct UserDataGatewayTest {
    var userDataGateway: UserDataGatewayAbstraction

    init() {
        userDataGateway = UserDataGatewayMock()
    }

    @Test mutating func testIfMethodGetCreatedUserReturnsCreatedUserFromService() async {
        userDataGateway = UserDataGatewayMock(getCreatedUserImplementation: { _ in
            return USER_MODEL
        })

        let createdUserFromService = try! await userDataGateway.getCreatedUser(
            user: USER_DATA_TRANSFER_OBJECT)

        #expect(createdUserFromService.id == USER_MODEL.id)
        #expect(createdUserFromService.username == USER_MODEL.username)
    }
}
