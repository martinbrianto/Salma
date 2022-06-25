//
//  ToolbarView.swift
//  SalmaKeyboard
//
//  Created by gratianus.brianto on 25/06/22.
//

import SwiftUI

struct ToolbarView: View {
    @State var preselectedIndex = 0
    var body: some View {
        ZStack {
            Color.gray.opacity(0.3).ignoresSafeArea()
            HStack(alignment: .center, spacing: 12) {
                Image(uiImage: UIImage(named: "Logo")!)
                CustomSegmentedControl(preselectedIndex: $preselectedIndex, options: ["Keyboard", "Autotext", "Transaction"])
                
            }
            .padding(12)
            .frame(height: 64, alignment: .center)
        }
        .frame(height: 64, alignment: .center)
            
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
                        .opacity(isSelected ? 1 : 0)
                        .onTapGesture {
                            withAnimation(.interactiveSpring(response: 0.2,
                                                             dampingFraction: 2,
                                                             blendDuration: 0.5)) {
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
