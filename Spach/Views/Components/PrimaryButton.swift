//
//  PrimaryButton.swift
//  Spach
//
//  Created by Andrew Valivaha on 22.04.2025.
//


import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: ()->Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.blue)
                .cornerRadius(10)
                .shadow(radius: 5)
        }
        .padding(.horizontal)
    }
}
