//
//  ToastView.swift
//  GitHubUsers
//
//  Created by Michael Arianto on 2025/05/14.
//

import SwiftUI

struct ToastView: View {
    @Binding var message: String?

    var body: some View {
        Text(message ?? "")
            .font(.caption)
            .padding()
            .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2)))
            .opacity(message != nil ? 1 : 0)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    message = nil
                }
            }
    }
}
