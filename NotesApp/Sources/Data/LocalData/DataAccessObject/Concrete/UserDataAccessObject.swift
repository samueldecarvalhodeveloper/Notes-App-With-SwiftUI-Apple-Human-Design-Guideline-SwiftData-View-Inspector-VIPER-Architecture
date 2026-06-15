import SwiftData

struct UserDataAccessObject: UserDataAccessObjectAbstraction {
    let databaseDriver: ModelContainer

    func getUsers() async throws -> [UserEntity] {
        return try await Task.detached {
            let modelContext = ModelContext(databaseDriver)
            let fetchDescriptor = FetchDescriptor<UserEntity>()

            return try modelContext.fetch(fetchDescriptor)
        }.value
    }

    func createdUser(user: UserEntity) async throws {
        let _ = try await Task.detached {
            let modelContext = ModelContext(databaseDriver)

            modelContext.insert(user)

            try modelContext.save()
        }.value
    }
}
