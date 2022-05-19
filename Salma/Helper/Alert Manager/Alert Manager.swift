//
//  Alert Manager.swift
//  Salma
//
//  Created by gratianus.brianto on 19/05/22.
//

import Foundation
import UIKit

class AlertManager {
    static let shared = AlertManager()
    
    private init(){}
    
    //use this alert for delete action
    func showDeleteAlertActionSheet(controller: UIViewController, onDeleteAction: @escaping ( (UIAlertAction) -> Void)) {
            let alert = UIAlertController(title: "", message: "Are you sure you want to do this?", preferredStyle: .actionSheet)

            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: onDeleteAction))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            controller.present(alert, animated: true, completion: nil )
        }
}
