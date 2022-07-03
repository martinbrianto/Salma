//
//  ToolbarView.swift
//  SalmaKeyboard
//
//  Created by gratianus.brianto on 25/06/22.
//

import UIKit
import SwiftUI
import KeyboardKit
import WebKit

struct ToolbarView: View {
    @State var preselectedIndex = 0
    let controller = KeyboardInputViewController.shared
    var body: some View {
        ZStack {
            Color.standardKeyboardBackground.ignoresSafeArea()
            VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 12) {
                Image(uiImage: UIImage(named: "Logo")!)
                    .onTapGesture {
                        openUrl(url: URL(string: "SalmaApp://"))
                    }
                CustomSegmentedControl(preselectedIndex: $preselectedIndex, options: ["Keyboard", "Autotext", "Transaction"])
            }
            .padding(12)
            .frame(height: 64, alignment: .center)
            KeyboardView(preselectedIndex: $preselectedIndex)
            }
        }
    }
    
    func openUrl(url: URL?) {
        let selector = sel_registerName("openURL:")
        var responder = controller as UIResponder?
        while let r = responder, !r.responds(to: selector) {
            responder = r.next
        }
        _ = responder?.perform(selector, with: url)
    }
}

struct CustomSegmentedControl: View {
    @Binding var preselectedIndex: Int
    var options: [String]
    let color = Color("Main")
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id:\.self) { index in
                let isSelected = preselectedIndex == index
                ZStack {
                    Rectangle()
                        .fill(color)
                        .cornerRadius(20)
                        .padding(0)
                        .opacity(isSelected ? 1 : 0.0000001)
                        .onTapGesture {
                            withAnimation(.interactiveSpring(response: 0.2,
                                                             dampingFraction: 1,
                                                             blendDuration: 0.2)) {
                                preselectedIndex = index
                            }
                        }
                }
                .overlay(
                    Text(options[index])
                        .font(Font.system(size: 12))
                        .fontWeight(.regular)
                        .foregroundColor(isSelected ? .white : .black)
                )
            }
        }
        .frame(height: 30)
        .cornerRadius(20)
    }
}

struct ToolbarView_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarView()
    }
}
