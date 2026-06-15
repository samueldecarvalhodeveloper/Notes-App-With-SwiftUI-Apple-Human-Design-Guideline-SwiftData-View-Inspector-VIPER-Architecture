let NOTE_MODEL = NoteModel(
    id: 10, title: "title", body: "body", createdAt: 0, updatedAt: 1, userId: USER.id)

let NOTE_DATA_TRANSFER_OBJECT = NoteDataTransferObject(
    title: NOTE_MODEL.title, body: NOTE_MODEL.body)

let NOTE_ENTITY = NOTE_MODEL.entity

let NOTE_BASE_ROUTE = "/notes/"
