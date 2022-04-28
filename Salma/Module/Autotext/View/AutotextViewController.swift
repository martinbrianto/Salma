//
//  AutotextViewController.swift
//  Salma
//
//  Created by Gratianus Martin on 4/12/22.
//

import UIKit

class AutotextViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var autotextTableView: UITableView!
    
    // MARK: - Variables
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNIB()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        autotextTableView.reloadData()
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

private extension AutotextViewController{
    private func registerNIB(){
        autotextTableView.register(AutotextTableViewCell.nib(), forCellReuseIdentifier: AutotextTableViewCell.reuseID)
    }
}

// MARK: - Tableview
extension AutotextViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autotextList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = autotextTableView.dequeueReusableCell(withIdentifier: AutotextTableViewCell.reuseID, for: indexPath) as! AutotextTableViewCell

        cell.autotextData = autotextList[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
