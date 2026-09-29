import SwiftUI

struct YourPlantsView: View {
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 16)], spacing: 16) {
                    ForEach(PlantModelRegistry.all) { plant in
                        VStack(spacing: 10) {
                            Image(plant.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 90)
                                .frame(maxWidth: .infinity)
                                .padding(8)
                                .background(Color.black.opacity(0.15))
                                .clipShape(RoundedRectangle(cornerRadius: 14))

                            Text(plant.displayName)
                                .font(.subheadline.bold())
                                .foregroundColor(.white)
                        }
                        .padding(12)
                        .background(Color.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.cardBorder, lineWidth: 1))
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Your Plants")
        .navigationBarTitleDisplayMode(.inline)
        .userMenu()
    }
}

#Preview {
    NavigationStack { YourPlantsView() }
}
