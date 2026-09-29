import SwiftUI

struct ResultView: View {
    let plant: Plant
    let image: UIImage

    @State private var diseaseInfo: DiseaseInfo?
    @State private var confidence: Double = 0
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var didSave = false
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var historyStore = ScanHistoryStore.shared

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            Group {
                if let info = diseaseInfo {
                    resultContent(info)
                } else if let msg = errorMessage {
                    ContentUnavailableView("No Results", systemImage: "exclamationmark.triangle", description: Text(msg))
                } else {
                    ProgressView("Analyzing...")
                        .tint(.accentGreen)
                }
            }
        }
        .navigationTitle("Results")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { runClassification() }
    }

    // MARK: - Content

    private func resultContent(_ info: DiseaseInfo) -> some View {
        ScrollView {
            VStack(spacing: 16) {
                headerBanner(info)
                summaryCard(info)

                InfoCard(title: "Symptoms") {
                    Text(info.symptoms).foregroundColor(.white.opacity(0.85))
                }

                InfoCard(title: "Botanical Cause") {
                    Text(info.cause).foregroundColor(.white.opacity(0.85))
                }

                InfoCard(title: "Treatment Plan") {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(info.treatment, id: \.self) { step in
                            Label(step, systemImage: "checkmark.seal")
                        }
                    }
                    .foregroundColor(.white.opacity(0.85))
                }

                InfoCard(title: "Prevention") {
                    Text(info.prevention).foregroundColor(.white.opacity(0.85))
                }

                actionButtons(info)
            }
            .padding()
        }
    }

    private func headerBanner(_ info: DiseaseInfo) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "leaf.fill")
                .font(.largeTitle)
                .foregroundColor(.white)
            Text(info.displayName)
                .font(.title2.bold())
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(LinearGradient(colors: [Color.alertAmber, Color.alertRed], startPoint: .leading, endPoint: .trailing))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func summaryCard(_ info: DiseaseInfo) -> some View {
        HStack(spacing: 14) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 56, height: 56)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .clipped()

            VStack(alignment: .leading) {
                Text(plant.displayName).font(.title3.bold()).foregroundColor(.white)
                Text("Plant").font(.subheadline).foregroundColor(.white.opacity(0.6))
            }

            Spacer()

            ZStack {
                Circle().stroke(Color.white.opacity(0.1), lineWidth: 6).frame(width: 60, height: 60)
                Circle()
                    .trim(from: 0, to: min(max(confidence, 0), 1))
                    .stroke(Color.accentGreen, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 60, height: 60)
                Text(String(format: "%.0f%%", confidence * 100))
                    .font(.caption.bold())
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.cardBorder, lineWidth: 1))
    }

    private func actionButtons(_ info: DiseaseInfo) -> some View {
        HStack(spacing: 12) {
            Button(didSave ? "Saved" : "Save to History") {
                historyStore.save(plant: plant.displayName, label: info.displayName, confidence: confidence, image: image)
                didSave = true
            }
            .disabled(didSave)
            .font(.headline.bold())
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.accentGreen)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Button("Re-scan") { dismiss() }
                .font(.headline.bold())
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.top, 10)
    }

    // MARK: - Classification

    private func runClassification() {
        // Guard against re-running if the view reappears (e.g. after a sheet dismiss).
        guard isLoading, diseaseInfo == nil, errorMessage == nil else { return }

        DiseaseClassifier.classify(image: image, plant: plant) { label, conf in
            DispatchQueue.main.async {
                self.isLoading = false

                if label.hasPrefix("Error") || label.hasPrefix("Unknown") {
                    self.errorMessage = label
                    return
                }

                let database = DiseaseDatabase.load(for: plant)
                guard let info = database[label] else {
                    self.errorMessage = "No matching disease data for \"\(label)\"."
                    return
                }

                self.diseaseInfo = info
                self.confidence = conf
            }
        }
    }
}

struct InfoCard<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title).font(.headline.bold()).foregroundColor(.white)
            Divider().background(Color.white.opacity(0.1))
            content
        }
        .padding()
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.cardBorder, lineWidth: 1))
    }
}

#Preview {
    NavigationStack {
        ResultView(plant: PlantModelRegistry.all[1], image: UIImage(systemName: "leaf.fill") ?? UIImage())
    }
}
