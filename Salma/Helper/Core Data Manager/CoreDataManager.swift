//
//  CoreDataManager.swift
//  Salma
//
//  Created by gratianus.brianto on 30/04/22.
//

import Foundation
import CoreData

struct CoreDataManager {
    static var shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Salma")
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    // MARK: - Core Data Function
    
    
    // MARK: - Autotext Custom
    func saveCustomAutotext(autotextData: Autotext){
        let context = CoreDataManager.shared.persistentContainer.viewContext
        guard let autotextCustomEntity = NSEntityDescription.entity(forEntityName: "CustomAutotext", in: context) else {
            return
        }
        let autotext = NSManagedObject(entity: autotextCustomEntity, insertInto: context)
        autotext.setValue(autotextData.title, forKey: "title")
        autotext.setValue(autotextData.messages, forKey: "messages")
        autotext.setValue(UUID(), forKey: "uuid")
        
        do {
            try context.save()
        } catch {
            fatalError()
        }
    }
    
    func fetchCustomAutotext(autotextID: UUID) -> CustomAutotext? {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = CustomAutotext.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", "\(autotextID)")
        do {
            let customAutotext = try context.fetch(fetchRequest).first
            return customAutotext
        } catch {
            print("could not fetch \(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchAllCustomAutotext() -> [Autotext]? {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = CustomAutotext.fetchRequest()
        do {
            let customAutotext = try context.fetch(fetchRequest)
            lazy var autotexts : [Autotext] = []
            for ca in customAutotext {
                autotexts.append(Autotext(title: ca.title, messages: ca.messages, id: ca.uuid))
            }
            return autotexts
        } catch {
            print("could not fetch \(error.localizedDescription)")
            return nil
        }
    }
    
    func updateCustomAutotext(autotextID: UUID, newAutotextData: Autotext) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        if let autotext = fetchCustomAutotext(autotextID: autotextID){
            autotext.title = newAutotextData.title
            autotext.messages = newAutotextData.messages
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        } else {
            print("Autotext not found")
        }
    }
    
    func deleteCustomAutotext(autotextID: UUID) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        if let autotext = fetchCustomAutotext(autotextID: autotextID){
            context.delete(autotext)
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        } else {
            print("Autotext not found")
        }
    }
    
    // MARK: - Autotext Default
    func saveDefaultAutotext(autotextData: Autotext){
        let context = CoreDataManager.shared.persistentContainer.viewContext
        guard let autotextCustomEntity = NSEntityDescription.entity(forEntityName: "DefaultAutotext", in: context) else {
            return
        }
        let autotext = NSManagedObject(entity: autotextCustomEntity, insertInto: context)
        autotext.setValue(autotextData.title, forKey: "title")
        autotext.setValue(autotextData.messages, forKey: "messages")
        autotext.setValue(UUID(), forKey: "uuid")
        
        do {
            try context.save()
        } catch {
            fatalError()
        }
    }
    
    func fetchDefaultAutotext(autotextID: UUID) -> DefaultAutotext? {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = DefaultAutotext.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", "\(autotextID)")
        do {
            let customAutotext = try context.fetch(fetchRequest).first
            return customAutotext
        } catch {
            print("could not fetch \(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchAllDefaultAutotext() -> [Autotext]? {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = DefaultAutotext.fetchRequest()
        do {
            let customAutotext = try context.fetch(fetchRequest)
            lazy var autotexts : [Autotext] = []
            for ca in customAutotext {
                autotexts.append(Autotext(title: ca.title, messages: ca.messages, id: ca.uuid))
            }
            return autotexts
        } catch {
            print("could not fetch \(error.localizedDescription)")
            return nil
        }
    }
    
    func updateDefaultAutotext(autotextID: UUID, newAutotextData: Autotext) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        if let autotext = fetchDefaultAutotext(autotextID: autotextID){
            autotext.title = newAutotextData.title
            autotext.messages = newAutotextData.messages
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        } else {
            print("Autotext not found")
        }
    }
    
    // MARK: - Profile Function
    /* Call this function to save new store profile in the on boarding */
    func saveProfile(newProfile: StoreProfile){
        let context = CoreDataManager.shared.persistentContainer.viewContext
        guard let storeProfileEntity = NSEntityDescription.entity(forEntityName: "Profile", in: context) else {
            return
        }
        
        let profile = NSManagedObject(entity: storeProfileEntity, insertInto: context)
        profile.setValue(newProfile.name, forKey: "storeName")
        profile.setValue(newProfile.phoneNumber, forKey: "storePhoneNumber")
        profile.setValue(newProfile.URL, forKey: "storeURL")
        profile.setValue(newProfile.location, forKey: "storeLocation")
        
        do {
            try context.save()
        } catch {
            fatalError()
        }
    }
    
    /* Call this function when we need to get profile info (name, phone number, url, location) */
    func fetchStoreProfile() -> StoreProfile? {
        var storeProfile: StoreProfile?
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = Profile.fetchRequest()
        do {
            if let profile = try context.fetch(fetchRequest).first {
                storeProfile = StoreProfile(
                    name: profile.storeName,
                    URL: profile.storeURL,
                    location: profile.storeURL,
                    phoneNumber: profile.storePhoneNumber
                )
            }
            
            return storeProfile
        } catch {
            print("could not fetch \(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchProfile() -> Profile? {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = Profile.fetchRequest()
        do {
            let profile = try context.fetch(fetchRequest).first
            return profile
        } catch {
            print("could not fetch \(error.localizedDescription)")
            return nil
        }
    }
    
    
    /* Call this function to update profile data */
    func updateProfile(newProfileData: StoreProfile) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        if let profile = CoreDataManager.shared.fetchProfile(){
            do {
                profile.setValue(newProfileData.name, forKey: "storeName")
                profile.setValue(newProfileData.phoneNumber, forKey: "storePhoneNumber")
                profile.setValue(newProfileData.URL, forKey: "storeURL")
                profile.setValue(newProfileData.location, forKey: "storeLocation")
                do {
                    try context.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        } else {
            print("No profile found")
        }
    }
    
    // MARK: - Product Function
    /* Call this function to save a new product */
    func saveProduct(newProduct: ProductModel ) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        guard let ProductEntity = NSEntityDescription.entity(forEntityName: "Product", in: context) else {
            return
        }
        let product = NSManagedObject(entity: ProductEntity, insertInto: context)
        product.setValue(newProduct.image, forKey: "image")
        product.setValue(newProduct.name, forKey: "name")
        product.setValue(newProduct.price, forKey: "price")
        product.setValue(newProduct.weight, forKey: "weight")
        product.setValue(0, forKey: "referenceCount")
        product.setValue(true, forKey: "isActive")
        product.setValue(UUID(), forKey: "uuid")
        do {
            try context.save()
        } catch {
            fatalError()
        }
    }
    // MARK: - Product Function
    
    /* Call this function to fetch all the product */
    func fetchAllProduct() -> [ProductModel]? {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = Product.fetchRequest()
        do {
            var productsList: [ProductModel] = []
            let products = try context.fetch(fetchRequest)
            for product in products {
                productsList.append(
                    ProductModel(
                        image: nil,
                        id: product.uuid,
                        name: product.name,
                        price: product.price,
                        weight: product.weight,
                        isActive: product.isActive
                    )
                )
            }
            return productsList
        } catch {
            print("could not fetch \(error.localizedDescription)")
            return nil
        }
    }
    
    /* Call this function to fetch a product with ID */
    func fetchOneProduct(productID: UUID) -> ProductModel? {
        var productModel: ProductModel?
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = Product.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", "\(productID)")
        do {
            if let product = try context.fetch(fetchRequest).first {
                productModel = ProductModel(
                    image: nil,
                    id: product.uuid,
                    name: product.name,
                    price: product.price,
                    weight: product.weight,
                    isActive: product.isActive
                )
            }
            return productModel
        } catch {
            print("could not fetch \(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchProduct(productID: UUID) -> Product? {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = Product.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", "\(productID)")
        do {
            let product = try context.fetch(fetchRequest).first
            return product
        } catch {
            print("could not fetch \(error.localizedDescription)")
            return nil
        }
    }
    
    /* Call this function to update a product with ID */
    func updateProduct(productID: UUID, newProductData: ProductModel) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        if let product = CoreDataManager.shared.fetchProduct(productID: productID) {
            product.setValue(newProductData.image, forKey: "image")
            product.setValue(newProductData.name, forKey: "name")
            product.setValue(newProductData.price, forKey: "price")
            product.setValue(newProductData.weight, forKey: "weight")
        }
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /* Call this function to delete a product with ID */
    func deleteProduct(productID: UUID) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        if let product = CoreDataManager.shared.fetchProduct(productID: productID) {
            if product.referenceCount > 0 {
                product.isActive = false
            } else {
                do {
                    context.delete(product)
                }
            }
            
            do {
                try context.save()
            } catch {
                print("\(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Transaction Function
    /* Call this function to save a new transaction */
    func saveTransaction(transactionData: TransactionModel) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        guard let transactionEntity = NSEntityDescription.entity(forEntityName: "Transaction", in: context) else {
            return
        }
        let transaction = NSManagedObject(entity: transactionEntity, insertInto: context)
        transaction.setValue(Date(), forKey: "date_created")
        transaction.setValue(UUID(), forKey: "uuid")
        transaction.setValue(transactionData.status.rawValue, forKey: "status")
        transaction.setValue(transactionData.customerName, forKey: "customer_name")
        transaction.setValue(transactionData.customerPhoneNumber, forKey: "customer_phone_number")
        transaction.setValue(transactionData.addressName, forKey: "address_name")
        transaction.setValue(transactionData.addressCity, forKey: "address_city")
        transaction.setValue(transactionData.addressDistrict, forKey: "address_district")
        transaction.setValue(transactionData.addressProvince, forKey: "address_province")
        transaction.setValue(transactionData.addressPostalCode, forKey: "address_postal_code")
        transaction.setValue(transactionData.expedition, forKey: "shipping_expedition")
        transaction.setValue(transactionData.shippingPrice, forKey: "shipping_price")
        transaction.setValue(transactionData.notes, forKey: "note")
        transaction.setValue(transactionData.priceSubTotal, forKey: "price_subTotal")
        transaction.setValue(transactionData.priceTotal, forKey: "price_Total")
        
        do {
            try context.save()
        } catch {
            fatalError()
        }
    }
    
    /* Call this function to update a trasaction with ID */
    func updateTransaction(transactionID: UUID, transactionData: TransactionModel){
        let context = CoreDataManager.shared.persistentContainer.viewContext
        if let transaction = CoreDataManager.shared.fetchTransaction(transactionID: transactionID) {
            transaction.setValue(transactionData.status.rawValue, forKey: "status")
            transaction.setValue(transactionData.customerName, forKey: "customer_name")
            transaction.setValue(transactionData.customerPhoneNumber, forKey: "customer_phone_number")
            transaction.setValue(transactionData.addressName, forKey: "address_name")
            transaction.setValue(transactionData.addressCity, forKey: "address_city")
            transaction.setValue(transactionData.addressDistrict, forKey: "address_district")
            transaction.setValue(transactionData.addressProvince, forKey: "address_province")
            transaction.setValue(transactionData.addressPostalCode, forKey: "address_postal_code")
            transaction.setValue(transactionData.expedition, forKey: "shipping_expedition")
            transaction.setValue(transactionData.shippingPrice, forKey: "shipping_price")
            transaction.setValue(transactionData.notes, forKey: "note")
            transaction.setValue(transactionData.priceSubTotal, forKey: "price_subTotal")
            transaction.setValue(transactionData.priceTotal, forKey: "price_Total")

            do {
                try context.save()
            } catch {
                fatalError()
            }
        }
    }
    
    /* Call this function to delete a trasaction with ID */
    func deleteTransaction(transactionID: UUID){
        let context = CoreDataManager.shared.persistentContainer.viewContext
        if let transaction = fetchTransaction(transactionID: transactionID) {
            // look for product in transaction, -1 reference count
            if let transactionProducts = transaction.transactionProducts {
                for tp in transactionProducts.array as! [TransactionProduct] {
                    tp.product.referenceCount -= 1
                    if tp.product.referenceCount == 0 && !tp.product.isActive {
                        context.delete(tp.product)
                    }
                }
            }
            //delete the transaction
            do {
                context.delete(transaction)
            }
            do {
                try context.save()
            } catch {
                print("\(error.localizedDescription)")
            }
        }
    }
    
    /* Call this function to update the trasaction complete date */
    func addTransactionCompleteDate(transactionID: UUID) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        if let transaction = fetchTransaction(transactionID: transactionID) {
            transaction.date_completed = Date()
        }
        
        do {
            try context.save()
        } catch {
            print("\(error.localizedDescription)")
        }
    }
    
    /* Call this function to update the trasaction paid date */
    func addTransactionPaidDate(transactionID: UUID) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        if let transaction = fetchTransaction(transactionID: transactionID) {
            transaction.date_paid = Date()
        }
        
        do {
            try context.save()
        } catch {
            print("\(error.localizedDescription)")
        }
    }
    
    /* Call this function to fetch all the avaiable trasaction paid date */
    func fetchAllTransaction() -> [TransactionModel]? {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = Transaction.fetchRequest()
        
        do {
            var transactionList: [TransactionModel] = []
            let transactions = try context.fetch(fetchRequest)
            for transaction in transactions {
                transactionList.append(
                    TransactionModel(
                        id: transaction.uuid,
                        status: Status.init(rawValue: transaction.status) ?? .notPaid,
                        dateCreated: transaction.date_created,
                        datePaid: transaction.date_paid,
                        dateCompleted: transaction.date_completed,
                        customerName: transaction.customer_name,
                        customerPhoneNumber: transaction.customer_phone_number,
                        addressName: transaction.address_name,
                        addressProvince: transaction.address_province,
                        addressCity: transaction.address_city,
                        addressDistrict: transaction.address_district,
                        addressPostalCode: transaction.address_postal_code,
                        notes: transaction.note,
                        expedition: transaction.shipping_expedition,
                        shippingPrice: transaction.shipping_price,
                        priceSubTotal: transaction.price_subTotal,
                        priceTotal: transaction.price_Total
                    )
                )
            }
            return transactionList
        } catch {
            print("could not fetch \(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchTransaction(transactionID: UUID) -> Transaction? {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = Transaction.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", "\(transactionID)")
        
        do {
            let transaction = try context.fetch(fetchRequest).first
            return transaction
        } catch {
            print("could not fetch \(error.localizedDescription)")
            return nil
        }
    }
    
    /* Call this function to fetch a transaction with ID */
    func fetchOneTransaction(transactionID: UUID) -> TransactionModel? {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = Transaction.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", "\(transactionID)")
        do {
            if let transaction = try context.fetch(fetchRequest).first {
                let transactionModel = TransactionModel(
                    id: transaction.uuid,
                    status: Status.init(rawValue: transaction.status) ?? .notPaid,
                    dateCreated: transaction.date_created,
                    datePaid: transaction.date_paid,
                    dateCompleted: transaction.date_completed,
                    customerName: transaction.customer_name,
                    customerPhoneNumber: transaction.customer_phone_number,
                    addressName: transaction.address_name,
                    addressProvince: transaction.address_province,
                    addressCity: transaction.address_city,
                    addressDistrict: transaction.address_district,
                    addressPostalCode: transaction.address_postal_code,
                    notes: transaction.note,
                    expedition: transaction.shipping_expedition,
                    shippingPrice: transaction.shipping_price,
                    priceSubTotal: transaction.price_subTotal,
                    priceTotal: transaction.price_Total
                )
                return transactionModel
            } else {
                return nil
            }
        } catch {
            print("could not fetch \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: - ProductTransaction Function
    /* Call this function to add a product to a transaction with ID */
    func addProductsToTransaction(transactionID: UUID, productID: UUID, quantity: Int32) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        guard let productTransactionEntity = NSEntityDescription.entity(forEntityName: "TransactionProduct", in: context) else { return }
        
        if let transaction = fetchTransaction(transactionID: transactionID), let product = fetchProduct(productID: productID) {
            let transactionProduct = NSManagedObject(entity: productTransactionEntity, insertInto: context)
            transactionProduct.setValue(product.price, forKey: "productPrice")
            transactionProduct.setValue(quantity, forKey: "productQuantity")
            transactionProduct.setValue(transaction, forKey: "ofTransaction")
            transactionProduct.setValue(product, forKey: "product")
            transaction.addToTransactionProducts(transactionProduct as! TransactionProduct)
            product.referenceCount += 1
            
        } else {
            print("no transaction/product found")
        }
        do {
            try context.save()
        } catch {
            print("\(error.localizedDescription)")
        }
    }
    
    /* Call this function to fetch all transactionProduct with ID */
    func fetchAllProductsOfTransaction(transactionID: UUID) -> [ProductModel]? {
        lazy var productList: [ProductModel] = []
        if let transaction = CoreDataManager.shared.fetchTransaction(transactionID: transactionID) {
            if let transactionProducts = transaction.transactionProducts?.array as? [TransactionProduct] {
                for transactionProduct in transactionProducts {
                    productList.append(ProductModel(image: nil, id: transactionProduct.product.uuid, name: transactionProduct.product.name, price: transactionProduct.product.price, weight: transactionProduct.product.weight, quantity: transactionProduct.productQuantity))
                }
                return productList
            }
        }
        return nil
    }
    
    func fetchProductsOfTransaction(transactionID: UUID) -> [TransactionProduct]? {
        lazy var productList: [ProductModel] = []
        if let transaction = CoreDataManager.shared.fetchTransaction(transactionID: transactionID) {
            if let transactionProducts = transaction.transactionProducts?.array as? [TransactionProduct] {
                return transactionProducts
            }
        }
        return nil
    }
    
    /* Call this function to update transactionProduct quantity with ID */
    func updateProductsOfTransactionQuantity(transactionID: UUID, productID: UUID, quantity: Int32) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        if let productTransactions = CoreDataManager.shared.fetchProductsOfTransaction(transactionID: transactionID) {
            if let productTransaction = productTransactions.first(where: { $0.product.uuid == productID }) {
                productTransaction.productQuantity = quantity
                do {
                    try context.save()
                } catch {
                    print("\(error.localizedDescription)")
                }
            }
        }
    }
    
    /* Call this function to delete transactionProduct of a transaction */
    func deleteProductsOfTransaction(transactionID: UUID, productID: UUID) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        if let productTransactions = CoreDataManager.shared.fetchProductsOfTransaction(transactionID: transactionID) {
            if let productTransaction = productTransactions.first(where: { $0.product.uuid == productID }) {
                let product = productTransaction.product
                product.referenceCount -= 1
                if product.referenceCount == 0 && !product.isActive{
                    do {
                        context.delete(product)
                    }
                }
                do {
                    context.delete(productTransaction)
                }
                do {
                    try context.save()
                } catch {
                    print("\(error.localizedDescription)")
                }
            }
        }
    }
}
