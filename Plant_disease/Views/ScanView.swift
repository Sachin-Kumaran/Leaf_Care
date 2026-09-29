import SwiftUI

struct ScanView: View {
    @State private var selectedPlant: Plant? = nil
    @State private var capturedImage: UIImage? = nil
    @State private var showingCamera = false
    @State private var showingLibrary = false
    @State private var navigateToResult = false

    private var cameraAvailable: Bool {
        UIImagePickerController.isSourceTypeAvailable(.camera)
    }

    private var canAnalyze: Bool {
        selectedPlant != nil && capturedImage != nil
    }

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    plantGrid
                    captureArea
                    analyzeButton
                }
                .padding(.vertical, 20)
            }
        }
        .navigationTitle("Scan a Plant")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingCamera) {
            ImagePicker(selectedImage: $capturedImage, sourceType: .camera)
                .ignoresSafeArea()
        }
        .sheet(isPresented: $showingLibrary) {
            ImagePicker(selectedImage: $capturedImage, sourceType: .photoLibrary)
                .ignoresSafeArea()
        }
        .navigationDestination(isPresented: $navigateToResult) {
            if let plant = selectedPlant, let image = capturedImage {
                ResultView(plant: plant, image: image)
            }
        }
    }

    // MARK: - Plant Grid

    private var plantGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("1. Choose a plant")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 90), spacing: 12)], spacing: 12) {
                ForEach(PlantModelRegistry.all) { plant in
                    PlantGridCell(plant: plant, isSelected: selectedPlant?.id == plant.id)
                        .onTapGesture { selectedPlant = plant }
                }
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Capture Area

    private var captureArea: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("2. Capture or upload a photo")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)

            VStack(spacing: 16) {
                photoPreview

                HStack(spacing: 12) {
                    Button {
                        showingCamera = true
                    } label: {
                        Label("Take Photo", systemImage: "camera.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.accentGreen)
                    .disabled(!cameraAvailable)

                    Button {
                        showingLibrary = true
                    } label: {
                        Label("Upload Photo", systemImage: "photo.on.rectangle")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.white)
                }
            }
            .padding()
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.cardBorder, lineWidth: 1))
            .padding(.horizontal)
        }
    }

    private var photoPreview: some View {
        Group {
            if let image = capturedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 220)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .clipped()
                    .overlay(alignment: .topTrailing) {
                        Button {
                            capturedImage = nil
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                                .shadow(radius: 4)
                                .padding(10)
                        }
                    }
            } else {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.05))
                    .frame(height: 220)
                    .overlay(
                        VStack(spacing: 8) {
                            Image(systemName: "photo.on.rectangle")
                                .font(.largeTitle)
                                .foregroundColor(.white.opacity(0.3))
                            Text("No photo yet")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.4))
                        }
                    )
            }
        }
    }

    // MARK: - Analyze

    private var analyzeButton: some View {
        Button {
            navigateToResult = true
        } label: {
            Text("Analyze")
                .font(.headline.bold())
                .foregroundColor(canAnalyze ? .black : .white.opacity(0.4))
                .frame(maxWidth: .infinity)
                .padding()
                .background(canAnalyze ? Color.accentGreen : Color.white.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .disabled(!canAnalyze)
        .padding(.horizontal)
    }
}

struct PlantGridCell: View {
    let plant: Plant
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 8) {
            Image(plant.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .padding(6)
                .background(Color.black.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            Text(plant.displayName)
                .font(.caption.bold())
                .foregroundColor(.white)
                .lineLimit(1)
        }
        .padding(8)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(isSelected ? Color.accentGreen : Color.cardBorder, lineWidth: isSelected ? 2 : 1)
        )
    }
}

#Preview {
    NavigationStack { ScanView() }
}
