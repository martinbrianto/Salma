//
//  TransactionDetailView.swift
//  SalmaKeyboard
//
//  Created by gratianus.brianto on 29/06/22.
//

import SwiftUI
import KeyboardKit

struct TransactionDetailView: View {
    @State var data: TransactionModel
    
    private let actionHandler: KeyboardActionHandler
    
    init(data: TransactionModel){
        let controller = KeyboardInputViewController.shared
        self.actionHandler = CustomKeyboardActionHandler(inputViewController: controller)
        _data = State(initialValue: data)
    }
    
    func fetchTransactionData() {
//        guard let id = data.id else { return }
//        if let fetchedTransaction = CoreDataManager.shared.fetchOneTransaction(transactionID: id) {
//            self.data = fetchedTransaction
//        }
    }
    
    var body: some View {
        
        ZStack {
            Color.standardKeyboardBackground.ignoresSafeArea()
            VStack {
                Color.white.overlay {
                    VStack {
                        HStack {
                            Text("\(data.dateCreated?.getFormattedDate(format: "dd MMMM YYYY") ?? "1 Juni 1970")")
                                .font(.system(size: 14, weight: .regular))
                            Spacer()
                            TransactionStatusView(transactionStatus: data.status)
                        }
                        Spacer()
                        HStack {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(data.customerName)
                                    .font(.system(size: 14, weight: .medium))
                                Text(data.customerPhoneNumber)
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            VStack(alignment: .trailing, spacing: 6) {
                                Text("Total Payment")
                                    .font(.system(size: 14, weight: .medium))
                                Text(data.priceTotal.formattedToRp)
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(Color("Main"))
                            }
                        }
                    }
                    .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                }
                .cornerRadius(8)
                HStack {
                    switch data.status {
                    case .notPaid:
                        Button(action: {
                            actionHandler.handle(.tap, on: .character(generateInvoice()))
                        }, label: {
                            Text("Send Invoice")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                        })
                        .buttonStyle(.automatic)
                        .frame(height: 32)
                        Button(action: {
                            if let id = data.id {
                                CoreDataManager.shared.addTransactionPaidDate(transactionID: id)
                            }
                            self.data.status = .inProgress
                        }, label: {
                            Text("Paid")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                        })
                        .buttonStyle(.borderedProminent)
                    case .inProgress:
                        Button(action: {
                            if let id = data.id {
                                CoreDataManager.shared.addTransactionCompleteDate(transactionID: id)
                            }
                            self.data.status = .completed
                        }, label: {
                            Text("Complete")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                        })
                        .buttonStyle(.borderedProminent)
                    default: Spacer()
                    }
                    
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 160)
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

extension TransactionDetailView {
    private func generateInvoice() -> String {
        guard let id = self.data.id else { return "" }
        guard let invoice = CoreDataManager.shared.fetchDefaultSendInvoice() else { return "" }
        var messages = invoice.messages
        let storeData = CoreDataManager.shared.fetchStoreProfile()
        var replacementData: String? = ""
        for tag in defaultAutoTextTagData.allCases {
            switch tag {
            case .storeName:
                replacementData = storeData?.name
            case .storeURL:
                replacementData = storeData?.URL
            case .storeLocation:
                replacementData = storeData?.location.name
            case .storePhoneNumber:
                replacementData = storeData?.phoneNumber
            case .customerName:
                replacementData = self.data.customerName
            case .customerPhoneNumber:
                replacementData = self.data.customerPhoneNumber
            case .customerAddress:
                let address = "\(self.data.addressName), \(self.data.addressDistrict), \(self.data.addressCity) \(self.data.addressProvince), \(self.data.addressPostalCode)"
                replacementData = address
            case .products:
                let products = CoreDataManager.shared.fetchProductsOfTransaction(transactionID: id) ?? []
                var tempProduct: String = ""
                products.forEach { product in
                    tempProduct += "-\(product.quantity)x \(product.name) @\(product.price.formattedToRp)\n"
                }
                replacementData = tempProduct
            case .shippingExpedition:
                replacementData = self.data.expedition
            case .shippingPrice:
                replacementData = self.data.shippingPrice.formattedToRp
            case .subTotalPrice:
                replacementData = self.data.priceSubTotal.formattedToRp
            case .totalPrice:
                replacementData = self.data.priceTotal.formattedToRp
            }
            messages = messages.replacingOccurrences(of: tag.rawValue, with: replacementData ?? "")
        }
        return messages
    }
}

struct buttonGroup: View {
    @Binding var status: Status
    var body: some View {
        HStack {
            switch status {
            case .notPaid:
                Button(action: {
                    // Whatever button action you want.
                }, label: {
                    Text("Send Invoice")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                })
                .buttonStyle(.automatic)
                .frame(height: 32)
                Button(action: {
                    // Whatever button action you want.
                }, label: {
                    Text("Paid")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                })
                .buttonStyle(.borderedProminent)
                .frame(height: 32)
            case .inProgress:
                Button(action: {
                    // Whatever button action you want.
                }, label: {
                    Text("Complete")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                })
                .buttonStyle(.borderedProminent)
                .frame(height: 32)
            default: Spacer()
            }
        }
    }
}

struct TransactionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionDetailView(data: TransactionModel(status: .notPaid, customerName: "", customerPhoneNumber: "", addressName: "", addressProvince: "", addressCity: "", addressDistrict: "", addressPostalCode: "", expedition: "", shippingPrice: 123, priceSubTotal: 333, priceTotal: 12500))
    }
}
