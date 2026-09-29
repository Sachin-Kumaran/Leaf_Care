import SwiftUI

struct SuggestionsView: View {
    private var currentMonthSuggestions: [String] {
        let month = Calendar.current.component(.month, from: Date())
        switch month {
        case 3...5: return ["Tomato", "Cucumber", "Marigold"]
        case 6...8: return ["Okra", "Chili Pepper", "Basil"]
        case 9...11: return ["Spinach", "Carrot", "Cauliflower"]
        default: return ["Peas", "Garlic", "Mustard Greens"]
        }
    }

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Good to plant this season")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal)

                    VStack(spacing: 12) {
                        ForEach(currentMonthSuggestions, id: \.self) { plant in
                            HStack {
                                Image(systemName: "leaf.fill").foregroundColor(.accentGreen)
                                Text(plant).font(.subheadline.bold()).foregroundColor(.white)
                                Spacer()
                            }
                            .padding()
                            .background(Color.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.cardBorder, lineWidth: 1))
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
        }
        .navigationTitle("Suggestions")
        .navigationBarTitleDisplayMode(.inline)
        .userMenu()
    }
}

#Preview {
    NavigationStack { SuggestionsView() }
}
