@preconcurrency import Alamofire

@preconcurrency struct UserDataGateway: UserDataGatewayAbstraction {
    private let httpClientImplementation: Session

    init(httpClientImplementation: Session) {
        self.httpClientImplementation = httpClientImplementation
    }

    func getCreatedUser(user: UserDataTransferObject) async throws -> UserModel {
        return try await httpClientImplementation.request(
            "\(SERVICE_URL)\(USER_BASE_ROUTE)", method: .post, parameters: user
        )
        .validate()
        .serializingDecodable(UserModel.self)
        .value
    }
}
