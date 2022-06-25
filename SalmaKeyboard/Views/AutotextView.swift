//
//  AutotextView.swift
//  SalmaKeyboard
//
//  Created by gratianus.brianto on 26/06/22.
//

import SwiftUI
import KeyboardKit

struct AutotextView: View {
    private var autotextData: [Autotext] = []
    private let actionData = ["+ Add Autotext", "Reset Autotext"]
    private let layoutConfig: KeyboardLayoutConfiguration
    private let keyboardWidth: CGFloat
    
    public init(keyboardContext: KeyboardContext, width:CGFloat? = nil) {
        let width = width ?? Self.standardKeyboardWidth
        self.layoutConfig = .standard(for: keyboardContext)
        self.keyboardWidth = width
    }
    init(
        controller: KeyboardInputViewController? = nil,
        width: CGFloat? = nil) {
        let controller = controller ?? .shared
        self.init(
            keyboardContext: controller.keyboardContext,
            width: width)
            fetchAllAutotext()
    }
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.3).ignoresSafeArea()
            VStack {
                Text("Action")
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                HStack(alignment: .center, spacing: 8) {
                    ForEach(0..<actionData.count) { index in
                        Button("\(actionData[index])") {
                            print(CoreDataManager.shared.fetchProfile())
                        }
                        .frame(width: (UIScreen.main.bounds.width/2) - 16, height: 36, alignment: .center)
                        .background(index == 0 ? Color("AddAT") : Color("ResetAT"))
                        .cornerRadius(4)
                        .foregroundColor(.black)
                    }
                }
                Text("Transaction")
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                HStack(alignment: .center, spacing: 8) {
                    ForEach(0..<autotextData.count) { index in
                        Button("\(autotextData[index].title)") {
                            print("hi")
                        }
                        .frame(width: (UIScreen.main.bounds.width/2) - 16, height: 36, alignment: .center)
                        .background(Color.white)
                        .cornerRadius(4)
                        .foregroundColor(.black)
                    }
                }
            }
            .frame(width: .infinity)
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            
        }
    }
}

extension AutotextView {
    static var standardKeyboardWidth: CGFloat {
        KeyboardInputViewController.shared.view.frame.width
    }
    
    private mutating func fetchAllAutotext() {
        autotextData.removeAll()
        autotextData.append(contentsOf: CoreDataManager.shared.fetchAllDefaultAutotext() ?? [])
        autotextData.append(contentsOf: CoreDataManager.shared.fetchAllCustomAutotext() ?? [])
        print(autotextData)
    }
}

struct AutotextView_Previews: PreviewProvider {
    static var previews: some View {
        AutotextView()
    }
}
