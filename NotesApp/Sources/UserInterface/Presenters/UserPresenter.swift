import SwiftUI

@Observable
@MainActor
class UserPresenter {
    private let userInteractor: UserInteractor
    private(set) var isInternetErrorRisen = false
    private(set) var isUserUsernameInvalid = false
    private(set) var user: User? = nil

    init(userInteractor: UserInteractor) {
        self.userInteractor = userInteractor
    }

    func verifyIfUserExists(onUserCreated: @escaping (Int) -> Void) {
        Task {
            do {
                let fetchedUser = try await self.userInteractor.getUser()

                self.user = fetchedUser

                onUserCreated(fetchedUser.id)
            }
        }

    }

    func createUser(username: String, onUserCreated: @escaping (Int) -> Void) {
        if username.isEmpty {
            isUserUsernameInvalid = true
            isInternetErrorRisen = false
        } else {
            Task {
                do {
                    user = try await userInteractor.getCreatedUser(username: username)

                    isInternetErrorRisen = false
                    isUserUsernameInvalid = false

                    onUserCreated(user!.id)
                } catch {
                    isInternetErrorRisen = true
                }
            }
        }
    }
}
