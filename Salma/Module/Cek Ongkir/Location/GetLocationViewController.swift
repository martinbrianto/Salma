//
//  GetLocationViewController.swift
//  Salma
//
//  Created by gratianus.brianto on 05/07/22.
//

import UIKit
import Atributika

protocol GetLocationViewControllerDelegate {
    func selectLocationFrom(_ location: SingleArea)
    func selectLocationTo(_ location: SingleArea)
}

class GetLocationViewController: UIViewController {

    @IBOutlet weak var serachBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var notFoundStack: UIStackView!
    
    enum GetLocationEntry {
        case from
        case to
    }
    var entryPoint: GetLocationEntry
    private var viewModel: GetLocationViewModel
    var delegate: GetLocationViewControllerDelegate?
    
    init(from: GetLocationEntry) {
        self.viewModel = GetLocationViewModel()
        self.entryPoint = from
        super.init(nibName: nil, bundle: nil)
        bindToViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func bindToViewModel() {
        viewModel.didUpdate = { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadData()
            if self.viewModel.fetchedData?.areas.count == 0 {
                self.tableView.isHidden = true
                self.notFoundStack.isHidden = false
            } else {
                self.tableView.isHidden = false
            }
        }
        
        viewModel.didLoading = { [weak self] _ in
            guard let self = self else { return }
            self.notFoundStack.isHidden = true
            if self.viewModel.isLoading {
                self.loadingIndicator.startAnimating()
            } else {
                self.loadingIndicator.stopAnimating()
            }
            self.tableView.isHidden = self.viewModel.isLoading
        }
    }
}

extension GetLocationViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.fetchedData?.areas.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.attributedText = NSAttributedString(string: viewModel.fetchedData?.areas[indexPath.row].name ?? "", attributes: [.font: Font.systemFont(ofSize: 12), .foregroundColor:UIColor.init(named: "Main") ?? UIColor.blue])
        cell.contentConfiguration = content
        cell.backgroundColor = UIColor.systemGroupedBackground
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let data = viewModel.fetchedData?.areas[indexPath.row] {
            switch entryPoint {
            case .from:
                self.delegate?.selectLocationFrom(data)
            case .to:
                self.delegate?.selectLocationTo(data)
            }
            self.dismiss(animated: true)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let search = searchBar.text{
            self.viewModel.getLocation(location: search)
        }
    }
    
    
}
