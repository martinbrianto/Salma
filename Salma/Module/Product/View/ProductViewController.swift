//
//  ProductViewController.swift
//  Salma
//
//  Created by Gratianus Martin on 4/12/22.
//

import UIKit

class ProductViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var noProductStackView: UIStackView!
    @IBOutlet weak var productTableView: UITableView!
    
    // MARK: - Variables
    private var viewModel: ProductVCVIewModel!
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(fetchFromBackground), name: .NSPersistentStoreRemoteChange, object: nil)
        viewModel = ProductVCVIewModel.init()
        registerNIB()
    }

     override func viewWillDisappear(_ animated: Bool) {
         self.navigationController?.setNavigationBarHidden(false, animated: animated);
         super.viewWillDisappear(animated)
     }

     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         fetchData()
         self.navigationController?.setNavigationBarHidden(true, animated: animated)
         if viewModel.fetchedData.count == 0 {
             noProductStackView.isHidden = false
             productTableView.isHidden = true
         }else{
             noProductStackView.isHidden = true
             productTableView.isHidden = false
         }
     }
    
    @objc func fetchFromBackground(){
        self.fetchData()
    }
    
    @IBAction func addProductButtonAction(_ sender: Any) {
        let viewController = ProductAddViewController(from: .add, viewModel: ProductAddVCViewModel(data: nil, productList: self.viewModel.fetchedData))
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: - ViewModel
    private func bindToViewModel() {
        viewModel.didUpdate = { [weak self] _ in
            self?.viewModelDidUpdate()
        }
        
        viewModel.didError = { [weak self] _ in
            self?.viewModelDidError()
        }
    }
    
    private func viewModelDidUpdate(){
        DispatchQueue.main.async {
            self.productTableView.reloadData()
        }
    }
    
    //TODO: error handling here
    private func viewModelDidError(){
        //handle error here
    }
    
    private func fetchData(){
        viewModel.fetchProductData()
    }
}

private extension ProductViewController{
    private func registerNIB(){
        productTableView.register(ProductTableViewCell.nib(), forCellReuseIdentifier: ProductTableViewCell.reuseID)
        self.bindToViewModel()
    }
}

 // MARK: - Tableview
extension ProductViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fetchedData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productTableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.reuseID, for: indexPath) as! ProductTableViewCell
        cell.productData = viewModel.fetchedData[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = viewModel.productAddVCViewModel(index: indexPath.row)
        let vc = ProductAddViewController(from: .details, viewModel: viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
