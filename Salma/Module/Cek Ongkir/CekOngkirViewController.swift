//
//  CekOngkirViewController.swift
//  Salma
//
//  Created by gratianus.brianto on 05/07/22.
//

import UIKit

enum CekOngkirEntry {
    case transaction
    case dashboard
}

protocol CekOngkirViewControllerDelegate {
    func fetchShippingRate(_ data: Pricing)
}

class CekOngkirViewController: UIViewController {

    @IBOutlet weak var fromTextfield: TextFieldView!
    @IBOutlet weak var toTextfield: TextFieldView!
    @IBOutlet weak var weightTextfield: TextFieldView!
    @IBAction func cekOngkirbtnAction(_ sender: UIButton) {
        if validateTextField() {
            let value = Int(weightTextfield.textfieldView.text ?? "0") ?? 0
            viewModel.setWeight(value)
            if let shippingViewModel = viewModel.shippingRateViewModel() {
                let vc = ShippingRateResultViewController(viewModel: shippingViewModel, entryPoint: self.entryPoint)
                vc.delegate = self
                switch entryPoint {
                case .transaction:
                    self.present(vc, animated: true)
                case .dashboard:
                    navigationController?.pushViewController(vc, animated: true)
                }
                
            }
        }
    }
    let entryPoint: CekOngkirEntry
    var delegate: CekOngkirViewControllerDelegate?
    private var viewModel: CekOngkirViewModel
    private var textfields: [TextFieldView] = []
    
    init(viewModel: CekOngkirViewModel, entryPoint: CekOngkirEntry) {
        self.entryPoint = entryPoint
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textfields = [fromTextfield, toTextfield, weightTextfield]
        setupTextfield()
        keyboardDismisser()
        title = "Cek Ongkir"
    }
}

extension CekOngkirViewController: UITextFieldDelegate, GetLocationViewControllerDelegate, ShippingRateResultViewControllerDelegate {
    func selectShippingRate(_ pricing: Pricing) {
        switch entryPoint {
        case .transaction:
            delegate?.fetchShippingRate(pricing)
            navigationController?.popViewController(animated: true)
        case .dashboard:
            break
        }
    }
    
    func selectLocationFrom(_ location: SingleArea) {
        fromTextfield.textfieldView.text = location.name
        viewModel.setFromLocation(location)
    }
    
    func selectLocationTo(_ location: SingleArea) {
        toTextfield.textfieldView.text = location.name
        viewModel.setToLocation(location)
    }
    
    private func keyboardDismisser(){
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    private func setupTextfield(){
        textfields.forEach({
            $0.textfieldView.delegate = self
        })
        fromTextfield.textfieldData = Textfield(title: "From", placeholder: "e.g. Province/District/City/Postal Code")
        toTextfield.textfieldData = Textfield(title: "To", placeholder: "e.g. Province/District/City/Postal Code")
        weightTextfield.textfieldData = Textfield(title: "Weight (g)", placeholder: "e.g. 1000")
        weightTextfield.textfieldView.keyboardType = .numberPad
        fromTextfield.textfieldView.addTarget(self, action: #selector(getLocationFrom), for: .touchDown)
        toTextfield.textfieldView.addTarget(self, action: #selector(getLocationTo), for: .touchDown)
        if let from = viewModel.from {
            fromTextfield.textfieldView.text = from.name
        }
        if let to = viewModel.to {
            toTextfield.textfieldView.text = to.name
        }
        
        if let weight = viewModel.weight {
            weightTextfield.textfieldView.text = String(weight)
        }
    }
    
    @objc private func getLocationFrom() {
        let vc = GetLocationViewController(from: .from)
        vc.modalPresentationStyle = .pageSheet
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    @objc private func getLocationTo() {
        let vc = GetLocationViewController(from: .to)
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.weightTextfield.textfieldView:
            self.weightTextfield.textfieldView.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    private func validateTextField() -> Bool {
        var errorCounter = 0
        
        textfields.forEach({
            if ($0.textfieldView.text ?? "").isEmpty {
                $0.errorMessage = "\($0.titleLabel.text ?? "") cannot be empty"
                errorCounter += 1
            } else {
                $0.errorMessage = nil
            }
        })
        return errorCounter == 0 ? true : false
    }
}
