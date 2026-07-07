import Foundation
import Combine

final class FurlogStore: ObservableObject {
    static let freeTierLimit = 20

    @Published var sessions: [GroomingSession] = [] { didSet { persist() } }

    private let fileURL: URL

    init() {
        let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: support, withIntermediateDirectories: true)
        fileURL = support.appendingPathComponent("furlogstore.json")
        load()
    }

    var isAtFreeLimit: Bool { sessions.count >= Self.freeTierLimit }

    func canAdd(isPro: Bool) -> Bool {
        isPro || sessions.count < Self.freeTierLimit
    }

    func add(_ entry: GroomingSession, isPro: Bool) -> Bool {
        guard canAdd(isPro: isPro) else { return false }
        sessions.append(entry)
        return true
    }

    func remove(at offsets: IndexSet) {
        sessions.remove(atOffsets: offsets)
    }

    func update(_ entry: GroomingSession) {
        if let idx = sessions.firstIndex(where: { $0.id == entry.id }) {
            sessions[idx] = entry
        }
    }

    private func seedIfNeeded() {
        if sessions.isEmpty {
            sessions = [Self.sampleSeed]
        }
    }

    private func persist() {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        if let data = try? encoder.encode(PersistedState(sessions: sessions)) {
            try? data.write(to: fileURL)
        }
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL) else {
            seedIfNeeded()
            return
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        if let state = try? decoder.decode(PersistedState.self, from: data) {
            self.sessions = state.sessions
            
        }
        seedIfNeeded()
    }

    struct PersistedState: Codable {
        var sessions: [GroomingSession]
        
    }
    static let sampleSeed = GroomingSession(petName: "Buddy", groomingType: "Bath & Trim", date: Date(), notes: "")
}
