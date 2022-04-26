//
//  ProductViewController.swift
//  Salma
//
//  Created by Gratianus Martin on 4/12/22.
//

import UIKit

class ProductViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var productTableView: UITableView!
    
    // MARK: - Variables
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNIB()

        // Do any additional setup after loading the view.
    }

     override func viewWillDisappear(_ animated: Bool) {
         self.navigationController?.setNavigationBarHidden(false, animated: animated);
         super.viewWillDisappear(animated)
     }

     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         self.navigationController?.setNavigationBarHidden(true, animated: animated)
     }
    
    @IBAction func addProductButtonAction(_ sender: Any) {
        let viewController = ProductAddViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

private extension ProductViewController{
    private func registerNIB(){
        productTableView.register(ProductTableViewCell.nib(), forCellReuseIdentifier: ProductTableViewCell.reuseID)
    }
}

 // MARK: - Tableview
extension ProductViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productTableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.reuseID, for: indexPath) as! ProductTableViewCell

        cell.productData = productList[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
