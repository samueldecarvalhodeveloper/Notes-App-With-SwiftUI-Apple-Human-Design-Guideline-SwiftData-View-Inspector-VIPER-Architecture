import Alamofire
import SwiftData

@MainActor
struct NoteManipulatingRouter {
    static var noteRepositoryInstance: NoteRepository?

    private init() {}

    static func build(noteId: Int, onNoteDeleted: @escaping () -> Void) -> NoteManipulatingView {
        let schema = Schema([NoteEntity.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        let modelContainer = try! ModelContainer(for: schema, configurations: modelConfiguration)
        let noteDataAccessObject = NoteDataAccessObject(databaseDriver: modelContainer)
        let httpClientImplementation = Session()
        let noteDataGateway = NoteDataGateway(httpClientImplementation: httpClientImplementation)
        let noteRepository: NoteRepository =
            noteRepositoryInstance
            ?? NoteRepository(
                noteDataAccessObject: noteDataAccessObject, noteDataGateway: noteDataGateway
            )
        let noteInteractor = NoteInteractor(noteRepository: noteRepository)
        let noteEditingPresenter = NoteEditingPresenter(
            noteId: noteId, noteInteractor: noteInteractor)

        return NoteManipulatingView(
            noteEditingPresenter: noteEditingPresenter, onNoteDeleted: onNoteDeleted)
    }
}
