import Testing

@testable import NotesApp

@MainActor
struct UserPresenterTest {
    var userDataAccessObject: UserDataAccessObjectAbstraction
    var userDataGateway: UserDataGatewayAbstraction
    var userRepository: UserRepository
    var userInteractor: UserInteractor
    var userPresenter: UserPresenter

    init() {
        userDataGateway = UserDataGatewayMock()
        userDataAccessObject = UserDataAccessObjectMock()
        userRepository = UserRepository(
            userDataAccessObject: userDataAccessObject, userDataGateway: userDataGateway)
        userInteractor = UserInteractor(userRepository: userRepository)

        userPresenter = UserPresenter(userInteractor: userInteractor)
    }

    @Test mutating func testIfMethodVerifyIfUserExistsLoadsUserDataAndExecutesOnUserCreatedAction()
        async
    {
        var createdUserId: Int?

        userDataAccessObject = UserDataAccessObjectMock(getUsersImplementation: {
            return [USER_ENTITY]
        })
        userRepository = UserRepository(
            userDataAccessObject: userDataAccessObject, userDataGateway: userDataGateway)
        userInteractor = UserInteractor(userRepository: userRepository)

        userPresenter = UserPresenter(userInteractor: userInteractor)

        userPresenter.verifyIfUserExists { userId in
            createdUserId = userId
        }

        await DataQueryingTimeout.waitQueryExecution()

        #expect(userPresenter.user!.id == USER_MODEL.id)
        #expect(userPresenter.user!.username == USER_MODEL.username)

        #expect(createdUserId == USER.id)
    }

    @Test
    mutating func
        testIfMethodCreateUserCreatesUserDataAndTurnsAnyCheckerFalseAndExecutesOnUserCreatedAction()
        async
    {
        var isLocalUserCreated = false
        var createdUserId: Int?

        userDataAccessObject = UserDataAccessObjectMock(createUserImplementation: { _ in
            isLocalUserCreated = true
        })
        userDataGateway = UserDataGatewayMock(getCreatedUserImplementation: { _ in
            return USER_MODEL
        })
        userRepository = UserRepository(
            userDataAccessObject: userDataAccessObject, userDataGateway: userDataGateway)
        userInteractor = UserInteractor(userRepository: userRepository)

        userPresenter = UserPresenter(userInteractor: userInteractor)

        userPresenter.createUser(username: USER.username) { userId in
            createdUserId = userId
        }

        await DataQueryingTimeout.waitQueryExecution()

        #expect(!userPresenter.isInternetErrorRisen)
        #expect(!userPresenter.isUserUsernameInvalid)

        #expect(isLocalUserCreated)

        #expect(createdUserId == USER.id)
    }

    @Test
    mutating func
        testIfMethodCreateUserMakesIsUserUsernameInvalidTrueIfUsernameIsNotValid()
        async
    {
        userPresenter.createUser(username: "") { _ in }

        await DataQueryingTimeout.waitQueryExecution()

        #expect(userPresenter.isUserUsernameInvalid)
    }

    @Test
    mutating func
        testIfMethodCreateUserMakesIsInternetErrorRisenTrueIfUserCreationFails()
        async
    {
        userDataGateway = UserDataGatewayMock(getCreatedUserImplementation: { _ in
            throw TestErrors.testForcedError
        })
        userRepository = UserRepository(
            userDataAccessObject: userDataAccessObject, userDataGateway: userDataGateway)
        userInteractor = UserInteractor(userRepository: userRepository)

        userPresenter = UserPresenter(userInteractor: userInteractor)

        userPresenter.createUser(username: "") { _ in }

        await DataQueryingTimeout.waitQueryExecution()

        #expect(userPresenter.isUserUsernameInvalid)
    }
}
