import Testing

@testable import NotesApp

@MainActor
struct UserInteractorTest {
    var userDataAccessObject: UserDataAccessObjectAbstraction
    var userDataGateway: UserDataGatewayAbstraction
    var userRepository: UserRepository
    var userInteractor: UserInteractor

    init() {
        userDataGateway = UserDataGatewayMock()
        userDataAccessObject = UserDataAccessObjectMock()
        userRepository = UserRepository(
            userDataAccessObject: userDataAccessObject, userDataGateway: userDataGateway)

        userInteractor = UserInteractor(userRepository: userRepository)
    }

    @Test mutating func testIfMethodGetUserReturnsUser() async {
        userDataAccessObject = UserDataAccessObjectMock(getUsersImplementation: {
            return [USER_ENTITY]
        })
        userRepository = UserRepository(
            userDataAccessObject: userDataAccessObject, userDataGateway: userDataGateway)

        userInteractor = UserInteractor(userRepository: userRepository)

        let userFromDatabase = try! await userInteractor.getUser()

        #expect(userFromDatabase.id == USER_MODEL.id)
        #expect(userFromDatabase.username == USER_MODEL.username)
    }

    @Test mutating func testIfMethodGetCreatedUserReturnsCreatedUser() async {
        var isUserCreated = false

        userDataAccessObject = UserDataAccessObjectMock(createUserImplementation: { _ in
            isUserCreated = true
        })
        userDataGateway = UserDataGatewayMock(getCreatedUserImplementation: { _ in USER_MODEL })
        userRepository = UserRepository(
            userDataAccessObject: userDataAccessObject, userDataGateway: userDataGateway)

        userInteractor = UserInteractor(userRepository: userRepository)

        let userFromDatabase = try! await userInteractor.getCreatedUser(
            username: USER_MODEL.username)

        #expect(userFromDatabase.id == USER_MODEL.id)
        #expect(userFromDatabase.username == USER_MODEL.username)
        #expect(isUserCreated)
    }
}
