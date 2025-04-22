//
//  IconSecureField.swift
//  Spach
//
//  Created by Andrew Valivaha on 22.04.2025.
//


import SwiftUI

struct IconSecureField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
            SecureField(placeholder, text: $text)
        }
        .padding()
        .background(Color.white.opacity(0.8))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
