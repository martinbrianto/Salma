//
//  TransactionView.swift
//  Salma
//
//  Created by gratianus.brianto on 28/06/22.
//

import SwiftUI
import KeyboardKit

enum KeyboardTransactionCellType {
    case addTransactionCell
    case transactionCell
}

struct TransactionKeyboardModel {
    var type: KeyboardTransactionCellType
    var transaction: TransactionModel
}

struct TransactionView: View {
    //private var transactionLists: [TransactionKeyboardModel] = []
    let controller = KeyboardInputViewController.shared
    @State private var transactionLists: [TransactionKeyboardModel] = []
    let layout = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init() {
        fetchTransaction()
    }
    
    func fetchTransaction() {
        var list = [TransactionKeyboardModel(type: .addTransactionCell, transaction: .initEmpty())]
        let transactionData: [TransactionKeyboardModel] = CoreDataManager.shared.fetchAllTransactionExceptPaid()?.compactMap { 
            TransactionKeyboardModel(type: .transactionCell, transaction: $0)
        } ?? []
        list.append(contentsOf: transactionData)
        self.transactionLists = list
    }
    
    var body: some View {
        NavigationView {
            
            ZStack() {
                ScrollView(.vertical, showsIndicators: true) {
                    LazyVGrid(columns: layout, spacing: 10) {
                        ForEach(0..<transactionLists.count, id:\.self) { index in
                            if transactionLists[index].type == .addTransactionCell {
                                AddTransactionView().onTapGesture {
                                    openUrl(url: URL(string: "SalmaApp://addTransaction"))
                                }
                            } else {
                                NavigationLink {
                                    TransactionDetailView(data: transactionLists[index].transaction)
                                        .onDisappear {
                                            fetchTransaction()
                                        }
                                } label: {
                                    TransactionCell(transactionData: transactionLists[index].transaction)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(Color.standardKeyboardBackground.ignoresSafeArea())
            .navigationBarHidden(true)
        }
        .frame(maxWidth: .infinity, minHeight: 216, maxHeight: .infinity)
        .onAppear {
            fetchTransaction()
        }
    }
}

extension TransactionView {
    func openUrl(url: URL?) {
        let selector = sel_registerName("openURL:")
        var responder = controller as UIResponder?
        while let r = responder, !r.responds(to: selector) {
            responder = r.next
        }
        _ = responder?.perform(selector, with: url)
    }
}

struct AddTransactionView: View {
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack {
                HStack(spacing: 0) {
                    Image(systemName: "plus")
                        .frame(width: 28, height: 28, alignment: .center)
                    Text("Add Transaction")
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundColor(Color("Main"))
            }
            .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 100, alignment: .leading )
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
            
        }
        .cornerRadius(8)
    }
}

struct TransactionCell: View {
    var transactionData: TransactionModel
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(transactionData.dateCreated?.getFormattedDate(format: "dd MMM YYYY") ?? "1 Juni 1970")
                        .font(.system(size: 10))
                    Spacer()
                    TransactionStatusView(transactionStatus: transactionData.status)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(transactionData.customerName)
                        .font(.system(size: 14, weight: .medium))
                    Text(transactionData.customerPhoneNumber)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total Payment")
                        .font(.system(size: 10, weight: .medium))
                    Text(transactionData.priceTotal.formattedToRp)
                        .font(.system(size: 14))
                        .foregroundColor(Color("Main"))
                }
                
            }
            .frame(maxWidth: .infinity ,maxHeight: 100, alignment: .leading )
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
        }
        .cornerRadius(8)
    }
}

struct TransactionStatusView: View {
    
    var transactionStatus: Status = .notPaid
    
    var body: some View {
        ZStack {
            switch transactionStatus {
            case .notPaid:
                Text("Not Paid")
                    .font(.system(size: 8, weight: .medium))
                    .foregroundColor(Color("Red"))
                    .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                    .background(Color("Error50"))
            case .inProgress:
                Text("In Progress")
                    .font(.system(size: 8, weight: .medium))
                    .foregroundColor(Color("Warning50"))
                    .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                    .background(Color("Yellow"))
            case .completed:
                Text("Paid")
                    .font(.system(size: 8, weight: .medium))
                    .foregroundColor(Color("Success700"))
                    .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                    .background(Color("Success50"))
            }
        }
        .frame( height: 16, alignment: .center)
        .cornerRadius(16)
    }
}



struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TransactionView()
        }
    }
}
