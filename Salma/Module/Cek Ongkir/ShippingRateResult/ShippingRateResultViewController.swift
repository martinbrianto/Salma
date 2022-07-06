//
//  ShippingRateResultViewController.swift
//  Salma
//
//  Created by gratianus.brianto on 06/07/22.
//

import UIKit

protocol ShippingRateResultViewControllerDelegate {
    func selectShippingRate(_ pricing:Pricing)
}

class ShippingRateResultViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    
    private let viewModel: ShippingRateViewModel
    let entryPoint: CekOngkirEntry
    var delegate: ShippingRateResultViewControllerDelegate?
    
    init(viewModel: ShippingRateViewModel, entryPoint: CekOngkirEntry){
        self.entryPoint = entryPoint
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bindToViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ShippingRateTableViewCell.nib(), forCellReuseIdentifier: ShippingRateTableViewCell.reusableID)
        viewModel.getShippingRate()
    }
    
    func bindToViewModel() {
        viewModel.didUpdate = { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
        
        viewModel.didLoading = { [weak self] _ in
            guard let self = self else { return }
            self.errorLabel.isHidden = true
            if self.viewModel.isLoading {
                self.loadingIndicator.startAnimating()
            } else {
                self.loadingIndicator.stopAnimating()
            }
            self.tableView.isHidden = self.viewModel.isLoading
        }
        
        viewModel.didError = { [weak self] _ in
            guard let self = self else { return }
            self.errorLabel.isHidden = false
            self.loadingIndicator.stopAnimating()
        }
    }
}

extension ShippingRateResultViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fetchedData?.pricing.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = viewModel.fetchedData?.pricing[indexPath.row] else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: ShippingRateTableViewCell.reusableID) as! ShippingRateTableViewCell
        cell.configureCell(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = viewModel.fetchedData?.pricing[indexPath.row] else { return }
        switch entryPoint {
        case .transaction:
            delegate?.selectShippingRate(data)
            self.dismiss(animated: true)
        case .dashboard:
            delegate?.selectShippingRate(data)
        }
        
    }
    
    
}
