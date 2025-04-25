import SwiftUI

/// Кастомний степпер із текстовою міткою і одиницею виміру
struct LabeledStepper: View {
    let title: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    let step: Int
    let unit: String

    init(title: String,
         value: Binding<Int>,
         range: ClosedRange<Int>,
         step: Int = 1,
         unit: String = "") {
        self.title = title
        self._value = value
        self.range = range
        self.step = step
        self.unit = unit
    }

    var body: some View {
        HStack {
            Text("\(title): \(value)\(unit)")
            Spacer()
            Stepper("", value: $value, in: range, step: step)
        }
        .padding(.vertical, 4)
    }
}
