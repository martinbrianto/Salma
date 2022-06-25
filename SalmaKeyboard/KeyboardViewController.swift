//
//  KeyboardViewController.swift
//  SalmaKeyboard
//
//  Created by gratianus.brianto on 30/04/22.
//

import UIKit
import KeyboardKit
import SwiftUI

class KeyboardViewController: UIInputViewController {
    
    override func viewWillSetupKeyboard() {
        super.viewWillSetupKeyboard()
        
        // Setup a demo-specific keyboard view
        //setup(with: AutotextView())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Perform custom UI setup here
        
    }
}
