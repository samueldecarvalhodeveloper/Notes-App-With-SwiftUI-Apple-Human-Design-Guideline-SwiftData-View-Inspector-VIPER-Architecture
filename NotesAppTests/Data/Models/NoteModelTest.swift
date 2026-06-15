import Testing

@testable import NotesApp

struct NoteModelTest {
    @Test func testIfPropertyEntityReturnsInstanceOfNoteEntityFromModel() {
        let instance = NoteModel(
            id: NOTE_MODEL.id,
            title: NOTE_MODEL.title,
            body: NOTE_MODEL.body,
            createdAt: NOTE_MODEL.createdAt,
            updatedAt: NOTE_MODEL.updatedAt,
            userId: NOTE_MODEL.userId
        ).entity

        #expect(instance.id == NOTE_ENTITY.id)
        #expect(instance.title == NOTE_ENTITY.title)
        #expect(instance.body == NOTE_ENTITY.body)
        #expect(instance.createdAt == NOTE_ENTITY.createdAt)
        #expect(instance.updatedAt == NOTE_ENTITY.updatedAt)
        #expect(instance.userId == NOTE_ENTITY.userId)
    }
}
