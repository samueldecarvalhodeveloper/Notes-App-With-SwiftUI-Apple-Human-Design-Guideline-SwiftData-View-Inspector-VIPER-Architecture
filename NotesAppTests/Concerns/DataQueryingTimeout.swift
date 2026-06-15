@testable import NotesApp

actor DataQueryingTimeout {
    private init() {}

    static func waitQueryExecution() async {
        try! await Task.sleep(nanoseconds: DATA_QUERY_EXECUTING_TIMEOUT)
    }
}
