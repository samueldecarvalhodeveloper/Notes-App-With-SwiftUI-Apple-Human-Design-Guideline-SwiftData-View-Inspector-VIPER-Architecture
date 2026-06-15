import Alamofire
import SwiftData

@MainActor
struct NotesListingRouter {
    static var noteRepositoryInstance: NoteRepository?

    private init() {}

    static func build(userId: Int, onNoteItemSelected: @escaping (Int) -> Void) -> NotesListingView
    {
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
        let notesListingPresenter = NotesListingPresenter(
            userId: userId, noteInteractor: noteInteractor)
        let userPresenter = UserPresenterFactory.getInstance()

        return NotesListingView(
            notesListingPresenter: notesListingPresenter,
            userPresenter: userPresenter,
            onNoteItemSelected: onNoteItemSelected
        )
    }
}
