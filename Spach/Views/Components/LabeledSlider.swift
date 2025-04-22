//
//  LabeledSlider.swift
//  Spach
//
//  Created by Andrew Valivaha on 22.04.2025.
//


import SwiftUI

struct LabeledSlider: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double

    init(title: String,
         value: Binding<Double>,
         range: ClosedRange<Double>,
         step: Double = 1
    ) {
        self.title = title
        self._value = value
        self.range = range
        self.step = step
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(title): \(value, specifier: step == 1 ? "%.0f" : "%.1f")")
                .font(.subheadline).bold()
            Slider(value: $value, in: range, step: step)
        }
        .padding(.horizontal)
    }
}
