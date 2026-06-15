import Alamofire

@MainActor
struct UserCreatingRouter {
    private init() {}

    static func build(onUserExisting: @escaping (Int) -> Void) -> UserCreatingView {
        let userPresenter = UserPresenterFactory.getInstance()

        return UserCreatingView(userPresenter: userPresenter, onUserExisting: onUserExisting)
    }
}
