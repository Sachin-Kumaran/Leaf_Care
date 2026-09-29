//
//  FAQItem.swift
//  Plant_disease
//
//  Created by Sachin  on 09/07/26.
//


import SwiftUI

struct FAQItem: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
}

struct FAQView: View {
    let faqs: [FAQItem] = [
        FAQItem(question: "How accurate is the detection?", answer: "Accuracy varies by plant and disease, typically 80-90% for well-lit, clear photos of a single leaf."),
        FAQItem(question: "What if my plant isn't listed?", answer: "We currently support a limited set of plants. More are being added over time."),
        FAQItem(question: "Does this work offline?", answer: "Yes — analysis runs entirely on your device.")
    ]

    var body: some View {
        List(faqs) { item in
            DisclosureGroup(item.question) {
                Text(item.answer).foregroundStyle(.secondary)
            }
        }
        .navigationTitle("FAQ")
    }
}