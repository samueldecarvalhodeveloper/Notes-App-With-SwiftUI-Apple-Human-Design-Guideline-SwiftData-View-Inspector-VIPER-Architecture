import Testing

@testable import NotesApp

@MainActor
struct UserDataAccessObjectTest {
    var userDataAccessObject: UserDataAccessObjectAbstraction

    init() {
        userDataAccessObject = UserDataAccessObjectMock()
    }

    @Test mutating func testIfMethodGetUsersReturnsListOfUsersFromDatabase() async {
        userDataAccessObject = UserDataAccessObjectMock(getUsersImplementation: {
            return [USER_ENTITY]
        })

        let listOfUsersFromDatabase = try! await userDataAccessObject.getUsers()

        #expect(listOfUsersFromDatabase.first!.id == USER_ENTITY.id)
        #expect(listOfUsersFromDatabase.first!.username == USER_ENTITY.username)
    }

    @Test mutating func testIfMethodCreatedUserCreatesUserOnDatabase() async {
        var isUserCreated = false

        userDataAccessObject = UserDataAccessObjectMock(createUserImplementation: { _ in
            isUserCreated = true
        })

        try! await userDataAccessObject.createdUser(user: USER_ENTITY)

        #expect(isUserCreated)
    }
}
