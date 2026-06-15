import SwiftUI
import Testing
import ViewInspector

@testable import NotesApp

@MainActor
struct UserCreatingViewTest {
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

    @Test mutating func testIfViewVerifiesIfUserExistsAndIfItIsTrueExecutesOnUserExisting()
        async throws
    {
        var createdUserId: Int?

        userDataAccessObject = UserDataAccessObjectMock(getUsersImplementation: { [USER_ENTITY] })
        userRepository = UserRepository(
            userDataAccessObject: userDataAccessObject, userDataGateway: userDataGateway)
        userInteractor = UserInteractor(userRepository: userRepository)

        let userPresenter = UserPresenter(userInteractor: userInteractor)

        let view = UserCreatingView(userPresenter: userPresenter) { userId in
            createdUserId = userId
        }

        ViewHosting.host(view: view)

        await DataQueryingTimeout.waitQueryExecution()

        #expect(createdUserId == USER.id)

        ViewHosting.expel()
    }

    @Test mutating func testIfViewCreatesUserAndExecutesOnUserExisting() async throws {
        var createdUserId: Int?

        userDataGateway = UserDataGatewayMock(getCreatedUserImplementation: { _ in USER_MODEL })
        userDataAccessObject = UserDataAccessObjectMock(
            getUsersImplementation: { [] }, createUserImplementation: { _ in })
        userRepository = UserRepository(
            userDataAccessObject: userDataAccessObject, userDataGateway: userDataGateway)
        userInteractor = UserInteractor(userRepository: userRepository)

        let userPresenter = UserPresenter(userInteractor: userInteractor)

        var view = UserCreatingView(userPresenter: userPresenter) { userId in
            createdUserId = userId
        }

        view.didAppear = { viewToBeInspected in
            let inspectableView = try viewToBeInspected.inspect()

            try inspectableView.find(ViewType.TextField.self).setInput(USER_MODEL.username)

            try inspectableView.find(ViewType.Button.self).tap()
        }

        ViewHosting.host(view: view)

        await DataQueryingTimeout.waitQueryExecution()

        #expect(createdUserId == USER.id)

        ViewHosting.expel()
    }

    @Test mutating func testIfViewShowsNotValidUsernameErrorMessageIfPassesUsernameIsNotValid()
        throws
    {
        var userCreatingErrorMessage: String!

        userDataAccessObject = UserDataAccessObjectMock(getUsersImplementation: { [] })
        userRepository = UserRepository(
            userDataAccessObject: userDataAccessObject, userDataGateway: userDataGateway)
        userInteractor = UserInteractor(userRepository: userRepository)

        let userPresenter = UserPresenter(userInteractor: userInteractor)

        var view = UserCreatingView(userPresenter: userPresenter) { _ in }

        view.didAppear = { viewToBeInspected in
            try viewToBeInspected.inspect().find(ViewType.Button.self).tap()
        }

        view.didUpdate = { viewToBeInspected in
            userCreatingErrorMessage = try viewToBeInspected.inspect().find(
                text: NOT_VALID_USERNAME_ERROR_MESSAGE
            ).string()
        }

        ViewHosting.host(view: view)

        #expect(userCreatingErrorMessage == NOT_VALID_USERNAME_ERROR_MESSAGE)

        ViewHosting.expel()
    }

    @Test mutating func testIfViewShowsNoAvailableInternetErrorMessageIfInternetIsNotAvaliable()
        async throws
    {
        var userCreatingErrorMessage: String!

        userDataAccessObject = UserDataAccessObjectMock(
            getUsersImplementation: { [] }, createUserImplementation: { _ in })
        userDataGateway = UserDataGatewayMock(getCreatedUserImplementation: { _ in
            throw TestErrors.testForcedError
        })
        userRepository = UserRepository(
            userDataAccessObject: userDataAccessObject, userDataGateway: userDataGateway)
        userInteractor = UserInteractor(userRepository: userRepository)

        let userPresenter = UserPresenter(userInteractor: userInteractor)

        var view = UserCreatingView(userPresenter: userPresenter) { _ in }

        view.didAppear = { viewToBeInspected in
            let inspectableView = try viewToBeInspected.inspect()

            try inspectableView.find(ViewType.TextField.self).setInput(USER_MODEL.username)

            try inspectableView.find(ViewType.Button.self).tap()
        }

        view.didUpdate = { viewToBeInspected in
            userCreatingErrorMessage = try viewToBeInspected.inspect().find(
                text: NO_AVAILABLE_INTERNET_ERROR_MESSAGE
            ).string()
        }

        ViewHosting.host(view: view)

        await DataQueryingTimeout.waitQueryExecution()

        #expect(userCreatingErrorMessage == NO_AVAILABLE_INTERNET_ERROR_MESSAGE)

        ViewHosting.expel()
    }
}
