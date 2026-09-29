import SwiftUI

struct HomeView: View {
    @ObservedObject private var historyStore = ScanHistoryStore.shared

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    header
                    scanCard
                    recentScans
                    quickActions
                    Spacer(minLength: 20)
                }
                .padding(.top, 12)
            }
        }
        .navigationTitle("PlantGuard")
        .navigationBarTitleDisplayMode(.inline)
        .userMenu()
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Welcome back")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.6))
            Text("Keep your garden healthy")
                .font(.title2.bold())
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }

    private var scanCard: some View {
        NavigationLink {
            ScanView()
        } label: {
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.accentGreen.opacity(0.15))
                        .frame(width: 80, height: 80)
                    Image(systemName: "viewfinder")
                        .font(.system(size: 36, weight: .semibold))
                        .foregroundColor(.accentGreen)
                }

                VStack(spacing: 4) {
                    Text("Scan a Plant")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                    Text("Select a plant and detect diseases instantly")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 30)
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.accentGreen.opacity(0.4), lineWidth: 1))
            .shadow(color: Color.accentGreen.opacity(0.15), radius: 15)
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
    }

    private var recentScans: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !historyStore.records.isEmpty {
                HStack {
                    Text("Recent Scans")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    NavigationLink {
                        ScanHistoryView()
                    } label: {
                        Text("See All")
                            .font(.subheadline)
                            .foregroundColor(.accentGreen)
                    }
                }

                VStack(spacing: 10) {
                    ForEach(historyStore.records.prefix(3)) { record in
                        HistoryCardCell(record: record)
                    }
                }
            }
        }
        .padding(.horizontal)
    }

    private var quickActions: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.headline)
                .foregroundColor(.white)

            HStack(spacing: 12) {
                NavigationLink {
                    ScanHistoryView()
                } label: {
                    QuickActionCard(title: "Scan History", icon: "clock.arrow.circlepath", color: .accentGreen)
                }
                .buttonStyle(.plain)

                NavigationLink {
                    FAQView()
                } label: {
                    QuickActionCard(title: "Tips & FAQ", icon: "questionmark.circle.fill", color: .cyan)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal)
    }
}

struct QuickActionCard: View {
    let title: String
    let icon: String
    let color: Color

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
            Text(title)
                .font(.subheadline.bold())
                .foregroundColor(.white)
            Spacer()
        }
        .padding()
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.cardBorder, lineWidth: 1))
    }
}

#Preview {
    NavigationStack { HomeView() }
} 
