//
//  ProductTransactionViewController.swift
//  Salma
//
//  Created by gratianus.brianto on 08/06/22.
//

import UIKit

protocol ProductTransactionViewControllerDelegate {
    func updateProductData(products: [ProductModel])
}

class ProductTransactionViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBAction func addButtonAction(_ sender: Any) {
        let products = viewModel.productData.filter {$0.quantity != 0}
        delegate?.updateProductData(products: products)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Privates
    private let viewModel: ProductTransactionVCViewModel
    var delegate: ProductTransactionViewControllerDelegate?
    var productCount: Int = 0
    init(viewModel: ProductTransactionVCViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNIB()
        bindToViewModel()
        viewModel.fetchProductData()
    }
    
    private func bindToViewModel() {
        viewModel.didUpdateProduct = { [weak self] _ in
            guard let self = self else { return }
            self.tableview.reloadData()
        }
        
        viewModel.didUpdate = { [weak self] _ in
            guard let self = self else { return }
            self.tableview.reloadData()
        }
    }
    
    private func updateProductTotal() {
        productCount = viewModel.productData.filter {$0.quantity != 0}.count
        addButton.setTitle("Add (\(productCount))", for: .normal)
    }
    
    
}

extension ProductTransactionViewController: ProductAddViewControllerDelegate {
    
    func addCustomProduct(product: ProductModel) {
        viewModel.addCustomProduct(product)
    }
    
    private func registerNIB() {
        tableview.register(TransactionListProductTableViewCell.nib(), forCellReuseIdentifier: TransactionListProductTableViewCell.reuseID)
        tableview.register(AddCustomProductTableViewCell.nib(), forCellReuseIdentifier: AddCustomProductTableViewCell.reuseID)
    }
    
}

extension ProductTransactionViewController: UITableViewDataSource, UITableViewDelegate, TransactionListProductTableViewCellDelegate {
    
    func updateQuantity(index: Int, quantity: Int32) {
        viewModel.updateQuantityOfProduct(index: index, quantity: quantity)
        print(">>> \(viewModel.productData[index])")
        updateProductTotal()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.cell[indexPath.row] {
        case .addCustomButton:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddCustomProductTableViewCell.reuseID) as! AddCustomProductTableViewCell
            return cell
        case .product:
            let cell = tableView.dequeueReusableCell(withIdentifier: TransactionListProductTableViewCell.reuseID) as! TransactionListProductTableViewCell
            cell.delegate = self
            cell.index = indexPath.row - 1
            cell.cellData = viewModel.productData[indexPath.row - 1]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.cell[indexPath.row] {
        case .addCustomButton:
            let vc = ProductAddViewController(from: .addCustom, viewModel: ProductAddVCViewModel(data: nil, productList: self.viewModel.productData))
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        case .product:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
}
