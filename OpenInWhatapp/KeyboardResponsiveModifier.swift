//
//  KeyboardResponsiveModifier.swift
//  OpenInWhatapp
//
//  Created by Amit Shilo on 07/04/2024.
//

import SwiftUI

struct KeyboardResponsiveModifier: ViewModifier {
    @State private var offset: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .padding(.bottom, offset)
            .onAppear {
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notif in
                    let value = notif.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                    let height = value.height
                    offset = height - (UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0)
                }

                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                    offset = 0
                }
            }
    }
}
