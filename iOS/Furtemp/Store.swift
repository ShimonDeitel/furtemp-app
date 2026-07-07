import Foundation

@MainActor
final class FurtempStore: ObservableObject {
    @Published private(set) var entries: [FurtempEntry] = []

    static let freeEntryLimit = 20

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        self.fileURL = dir.appendingPathComponent("furtemp_entries.json")
        if ProcessInfo.processInfo.arguments.contains("-uiTestReset") {
            try? FileManager.default.removeItem(at: fileURL)
        }
        load()
        if entries.isEmpty {
            seedDefaults()
        }
    }

    private func seedDefaults() {
        let cal = Calendar.current
        entries = [
            FurtempEntry(date: cal.date(byAdding: .day, value: -9, to: Date())!, temperature: 101.5, notes: "Resting comfortably"),
            FurtempEntry(date: cal.date(byAdding: .day, value: -6, to: Date())!, temperature: 102.8, notes: "Slightly warm, monitoring"),
            FurtempEntry(date: cal.date(byAdding: .day, value: -3, to: Date())!, temperature: 101.2, notes: "Back to normal")
        ]
        save()
    }

    func canAddEntry(isPro: Bool) -> Bool {
        isPro || entries.count < Self.freeEntryLimit
    }

    @discardableResult
    func addEntry(date: Date, temperature: Double, notes: String, isPro: Bool) -> Bool {
        guard canAddEntry(isPro: isPro) else { return false }
        let entry = FurtempEntry(date: date, temperature: temperature, notes: notes)
        entries.append(entry)
        entries.sort { $0.date > $1.date }
        save()
        return true
    }

    func updateEntry(_ id: UUID, date: Date, temperature: Double, notes: String) {
        guard let idx = entries.firstIndex(where: { $0.id == id }) else { return }
        entries[idx].date = date
        entries[idx].temperature = temperature
        entries[idx].notes = notes
        entries.sort { $0.date > $1.date }
        save()
    }

    func deleteEntry(_ id: UUID) {
        entries.removeAll { $0.id == id }
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func deleteAllData() {
        entries = []
        seedDefaults()
    }

    // MARK: - Persistence

    private struct Snapshot: Codable {
        var entries: [FurtempEntry]
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        if let decoded = try? JSONDecoder().decode(Snapshot.self, from: data) {
            entries = decoded.entries
        }
    }

    private func save() {
        let snapshot = Snapshot(entries: entries)
        guard let data = try? JSONEncoder().encode(snapshot) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
