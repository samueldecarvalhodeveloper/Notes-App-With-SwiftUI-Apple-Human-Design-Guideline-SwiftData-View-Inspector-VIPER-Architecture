import Testing

@testable import NotesApp

struct UserModelTest {
    @Test func testIfPropertyEntityReturnsInstanceOfUserEntityFromModel() {
        let instance = UserModel(id: USER_MODEL.id, username: USER_MODEL.username).entity

        #expect(instance.id == USER_ENTITY.id)
        #expect(instance.username == USER_ENTITY.username)
    }
}
