import Testing

@testable import NotesApp

@MainActor
struct UserRepositoryTest {
    var userDataAccessObject: UserDataAccessObjectAbstraction
    var userDataGateway: UserDataGatewayAbstraction
    var userRepository: UserRepository

    init() {
        userDataGateway = UserDataGatewayMock()
        userDataAccessObject = UserDataAccessObjectMock()

        userRepository = UserRepository(
            userDataAccessObject: userDataAccessObject, userDataGateway: userDataGateway)
    }

    @Test mutating func testIfMethodGetUserReturnsUserFromDatabase() async {
        userDataAccessObject = UserDataAccessObjectMock(getUsersImplementation: {
            return [USER_ENTITY]
        })

        userRepository = UserRepository(
            userDataAccessObject: userDataAccessObject, userDataGateway: userDataGateway)

        let userFromDatabase = try! await userRepository.getUser()

        #expect(userFromDatabase.id == USER_MODEL.id)
        #expect(userFromDatabase.username == USER_MODEL.username)
    }

    @Test mutating func testIfMethodGetUserThrowsNotExistingUserErrorIfUserDoesNotExist() async {
        userDataAccessObject = UserDataAccessObjectMock(getUsersImplementation: {
            return []
        })

        userRepository = UserRepository(
            userDataAccessObject: userDataAccessObject, userDataGateway: userDataGateway)

        do {
            let _ = try await userRepository.getUser()
        } catch {
            #expect(error as! UserErrors == UserErrors.notExistingUserError)
        }
    }

    @Test mutating func testIfMethodGetCreatedUserReturnsCreatedUserOnDatabaseAndService() async {
        var isUserCreated = false

        userDataAccessObject = UserDataAccessObjectMock(createUserImplementation: { _ in
            isUserCreated = true
        })
        userDataGateway = UserDataGatewayMock(getCreatedUserImplementation: { _ in USER_MODEL })

        userRepository = UserRepository(
            userDataAccessObject: userDataAccessObject, userDataGateway: userDataGateway)

        let userFromDatabase = try! await userRepository.getCreatedUser(
            username: USER_MODEL.username)

        #expect(userFromDatabase.id == USER_MODEL.id)
        #expect(userFromDatabase.username == USER_MODEL.username)
        #expect(isUserCreated)
    }
}
