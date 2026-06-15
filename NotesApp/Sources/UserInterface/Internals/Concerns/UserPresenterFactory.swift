import Alamofire
import SwiftData

@MainActor
struct UserPresenterFactory {
    static var userRepositoryInstance: UserRepository?
    static private var instance: UserPresenter?

    private init() {}

    static func getInstance() -> UserPresenter {
        if instance == nil {
            let schema = Schema([UserEntity.self])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            let modelContainer = try! ModelContainer(
                for: schema, configurations: modelConfiguration)
            let userDataAccessObject = UserDataAccessObject(databaseDriver: modelContainer)
            let httpClientImplementation = Session()
            let userDataGateway = UserDataGateway(
                httpClientImplementation: httpClientImplementation)
            let userRepository: UserRepository =
                userRepositoryInstance
                ?? UserRepository(
                    userDataAccessObject: userDataAccessObject, userDataGateway: userDataGateway
                )
            let userInteractor = UserInteractor(userRepository: userRepository)

            instance = UserPresenter(userInteractor: userInteractor)
        }

        return instance!
    }
}
