import SwiftUI

struct ScanHistoryView: View {
    @ObservedObject private var store = ScanHistoryStore.shared
    @State private var searchText = ""

    private var filteredRecords: [ScanRecord] {
        guard !searchText.isEmpty else { return store.records }
        return store.records.filter {
            $0.plantName.localizedCaseInsensitiveContains(searchText) ||
            $0.diseaseLabel.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            VStack(spacing: 16) {
                searchBar

                if filteredRecords.isEmpty {
                    emptyState
                } else {
                    List {
                        ForEach(filteredRecords) { record in
                            HistoryCardCell(record: record)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        delete(record)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    .tint(Color.alertRed)
                                }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
        }
        .navigationTitle("Scan History")
        .navigationBarTitleDisplayMode(.inline)
        .userMenu()
    }

    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass").foregroundColor(.white.opacity(0.5))
            TextField("Search scans", text: $searchText)
                .foregroundColor(.white)
        }
        .padding(10)
        .background(Color.white.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal)
        .padding(.top, 8)
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.largeTitle)
                .foregroundColor(.white.opacity(0.3))
            Text(store.records.isEmpty ? "No scans yet" : "No matching scans")
                .foregroundColor(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func delete(_ record: ScanRecord) {
        store.records.removeAll { $0.id == record.id }
    }
}

struct HistoryCardCell: View {
    let record: ScanRecord

    private var isWarning: Bool {
        record.diseaseLabel.localizedCaseInsensitiveCompare("Healthy") != .orderedSame
    }

    var body: some View {
        HStack(spacing: 14) {
            if let image = UIImage(data: record.imageData) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .clipped()
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(record.plantName)
                    .font(.headline.bold())
                    .foregroundColor(.white)

                Text(record.diseaseLabel)
                    .font(.caption.bold())
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(isWarning ? Color.alertRed.opacity(0.25) : Color.accentGreen.opacity(0.2))
                    .foregroundColor(isWarning ? Color.alertRed : Color.accentGreen)
                    .clipShape(Capsule())

                HStack {
                    Text(record.date.formatted(date: .abbreviated, time: .shortened))
                    Spacer()
                    Text(String(format: "%.0f%% Confidence", record.confidence * 100))
                }
                .font(.caption2)
                .foregroundColor(.white.opacity(0.5))
            }
        }
        .padding(12)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.cardBorder, lineWidth: 1))
    }
}

#Preview {
    NavigationStack { ScanHistoryView() }
}
