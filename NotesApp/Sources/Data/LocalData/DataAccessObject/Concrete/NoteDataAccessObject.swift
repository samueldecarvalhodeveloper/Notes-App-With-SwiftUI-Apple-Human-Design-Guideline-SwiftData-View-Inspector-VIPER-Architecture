import SwiftData
import Foundation

struct NoteDataAccessObject: NoteDataAccessObjectAbstraction {
    let databaseDriver: ModelContainer
    
    func getNotes() async throws -> [NoteEntity] {
        return try await Task.detached {
            let modelContext = ModelContext(databaseDriver)
            let fetchDescriptor = FetchDescriptor<NoteEntity>()
            
            return try modelContext.fetch(fetchDescriptor)
        }.value
    }

    func getNote(noteId: Int) async throws -> NoteEntity {
        return try await Task.detached {
            let modelContext = ModelContext(databaseDriver)
            let fetchDescriptor = FetchDescriptor<NoteEntity>(
                predicate: #Predicate { $0.id == noteId }
            )
            
            return try modelContext.fetch(fetchDescriptor).first!
        }.value
    }

    func createNote(note: NoteEntity) async throws {
        let _ = try await Task.detached {
            let modelContext = ModelContext(databaseDriver)
            
            modelContext.insert(note)
            
            try modelContext.save()
        }.value
    }

    func updateNote(note: NoteEntity) async throws {
        let _ = try await Task.detached {
            let modelContext = ModelContext(databaseDriver)
            
            try modelContext.save()
        }.value
    }

    func deleteNotes() async throws {
        let _ = try await Task.detached {
            let modelContext = ModelContext(databaseDriver)
            
            try modelContext.delete(model: NoteEntity.self)
            
            try modelContext.save()
        }.value
    }

    func deleteNote(id: Int) async throws {
        let _ = try await Task.detached {
            let modelContext = ModelContext(databaseDriver)
            let fetchDescriptor = FetchDescriptor<NoteEntity>(
                predicate: #Predicate { $0.id == id }
            )
            
            if let noteToBeDeleted = try modelContext.fetch(fetchDescriptor).first {
                modelContext.delete(noteToBeDeleted)
            }
            
            try modelContext.save()
        }.value
    }

}
