//
//  TextFieldView.swift
//  Salma
//
//  Created by gratianus.brianto on 21/04/22.
//

import UIKit
import SwiftUI

class TextFieldView: UIView {
    
    // MARK: - Outlets
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textfieldBackground: UIView!
    @IBOutlet weak var textfieldView: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    // MARK: - Variable
    var errorMessage: String? {
        didSet {
            if let errorMessage = errorMessage {
                textfieldBackground.borderWidth = 1
                textfieldBackground.borderColor = UIColor(named: "Red")
                textfieldBackground.backgroundColor = UIColor(named: "Error50")
                errorMessageLabel.text = errorMessage
                errorMessageLabel.isHidden = false
            } else {
                textfieldBackground.borderWidth = 0
                textfieldBackground.backgroundColor = UIColor(named: "PlaceholderBg")
                errorMessageLabel.isHidden = true
            }
        }
    }
    
    var isEnabled: Bool = true{
        didSet {
            if isEnabled {
                textfieldView.isEnabled = isEnabled
                textfieldView.textColor = UIColor.darkText
            } else {
                textfieldView.isEnabled = isEnabled
                textfieldView.textColor = UIColor(named: "textFieldDisabled")
            }
        }
    }
    
    var textfieldData: Textfield? {
        didSet {
            setupTextField()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("TextFieldView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        textfieldView.returnKeyType = .next
    }
}

extension TextFieldView {
    func setupTextField() {
        if let textfieldData = textfieldData {
            titleLabel.text = textfieldData.title
            textfieldView.placeholder = textfieldData.placeholder
        }
    }
}
