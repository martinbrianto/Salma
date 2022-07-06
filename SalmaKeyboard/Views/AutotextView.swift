//
//  AutotextView.swift
//  SalmaKeyboard
//
//  Created by gratianus.brianto on 26/06/22.
//

import SwiftUI
import KeyboardKit

struct AutotextView: View {
    
    @State private var autotextData: [Autotext] = []
    let controller = KeyboardInputViewController.shared
    
    private let actionHandler: KeyboardActionHandler
    init(){
        self.actionHandler = CustomKeyboardActionHandler(inputViewController: controller)
        fetchAllAutotext()
    }
    
    private let actionData = ["+ Add Autotext", "Reset Autotext"]
    let layout = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            Color.standardKeyboardBackground.ignoresSafeArea()
            VStack(alignment: .leading) {
                ScrollView {
                    Text("Action")
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    HStack(alignment: .center, spacing: 8) {
                        LazyVGrid(columns: layout){
                            ForEach(0..<actionData.count) { index in
                                Button("\(actionData[index])") {
                                    if actionData[index] == "Reset Autotext" {
                                        actionHandler.handle(.tap, on: .custom(named: "deleteAll"))
                                    } else {
                                        openUrl(url: URL(string: "SalmaApp://addAutotext"))
                                    }
                                }
                                .frame(maxWidth: .infinity, minHeight: 40,maxHeight: 40)
                                .background(index == 0 ? Color("AddAT") : Color("ResetAT"))
                                .cornerRadius(4)
                                .foregroundColor(.black)
                            }
                        }
                    }
                    Text("Transaction")
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    HStack(alignment: .center, spacing: 8) {
                        LazyVGrid(columns: layout){
                            ForEach(0..<autotextData.count, id:\.self) { index in
                                Button("\(autotextData[index].title)") {
                                    actionHandler.handle(.tap, on: .character(generateAutotext(messages: autotextData[index].messages)))
                                }
                                .frame(maxWidth: .infinity, minHeight: 40,maxHeight: 40)
                                .background(Color.white)
                                .cornerRadius(4)
                                .foregroundColor(.black)
                            }
                        }
                    }
                }
            }
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            
        }
        .frame(maxWidth: .infinity, minHeight: 216, maxHeight: 216)
        .onAppear {
            fetchAllAutotext()
        }
    }
}

extension AutotextView {
    func openUrl(url: URL?) {
        let selector = sel_registerName("openURL:")
        var responder = controller as UIResponder?
        while let r = responder, !r.responds(to: selector) {
            responder = r.next
        }
        _ = responder?.perform(selector, with: url)
    }
}

extension AutotextView {
    private func fetchAllAutotext() {
        var data: [Autotext] = []
        let formatOrder = CoreDataManager.shared.fetchDefaultFormatOrder() ?? Autotext(title: "", messages: "")
        let customAutotext = CoreDataManager.shared.fetchAllCustomAutotext() ?? []
        data.append(formatOrder)
        data.append(contentsOf: customAutotext)
        self.autotextData = data
        
    }
    
    private func generateAutotext(messages: String) -> String {
            var messages = messages
            let storeData = CoreDataManager.shared.fetchStoreProfile()
            var data: String? = ""
            for tag in customAutoTextTagData.allCases{
                switch tag {
                case .storeName:
                    data = storeData?.name
                case .storeURL:
                    data = storeData?.URL
                case .storeLocation:
                    data = storeData?.location.name
                case .storePhoneNumber:
                    data = storeData?.phoneNumber
                }
                messages = messages.replacingOccurrences(of: tag.rawValue, with: data ?? "")
            }
            return messages
    }
}

struct AutotextView_Previews: PreviewProvider {
    static var previews: some View {
        AutotextView()
    }
    
    
}
