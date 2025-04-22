//
//  CardContainer.swift
//  Spach
//
//  Created by Andrew Valivaha on 22.04.2025.
//


import SwiftUI

struct CardContainer<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: ()->Content) {
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 16) {
            content
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding(.horizontal)
    }
}
