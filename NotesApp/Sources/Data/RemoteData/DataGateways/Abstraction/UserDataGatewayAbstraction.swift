@MainActor
protocol UserDataGatewayAbstraction {
    func getCreatedUser(user: UserDataTransferObject) async throws -> UserModel
}
