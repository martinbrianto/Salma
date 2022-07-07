//
//  FetchingDataViewController.swift
//  Salma
//
//  Created by gratianus.brianto on 08/07/22.
//

import UIKit

class FetchingDataViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        // Do any additional setup after loading the view.
    }

    static func showAlert(from viewController: UIViewController) {
        let controller = FetchingDataViewController.init(nibName: "AlertStandardViewController", bundle: nil)
        viewController.navigationController?.modalPresentationStyle = .overCurrentContext
        viewController.present(controller, animated: true, completion: nil)
    }

}
