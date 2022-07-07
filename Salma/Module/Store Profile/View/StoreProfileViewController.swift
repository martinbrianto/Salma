//
//  StoreProfileViewController.swift
//  Salma
//
//  Created by gratianus.brianto on 25/04/22.
//

import UIKit

class StoreProfileViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UIView!
    @IBOutlet weak var storeNameTextField: TextFieldView!
    @IBOutlet weak var storeURLTextField: TextFieldView!
    @IBOutlet weak var storeLocationTextField: TextFieldView!
    @IBOutlet weak var phoneNumberTextField: TextFieldView!
    @IBOutlet weak var nextButton: UIButton!
    @IBAction func nextButtonAction(_ sender: Any) {
        if validateTextField() {
            guard let location = viewModel.fetchedLocation else {return}
            let profile = StoreProfile(
                name: storeNameTextField.textfieldView.text ?? "",
                URL: storeURLTextField.textfieldView.text ?? "",
                location: location,
                phoneNumber: phoneNumberTextField.textfieldView.text ?? ""
            )
            viewModel.updateStoreProfile(profile)
            let vc = EnableKeyboardViewController(from: .onboarding)
            setupFirstTimeAutotext()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - Variable
    private var viewModel: StoreProfileVCViewModel!
    private var entryPoint: StoreProfilePageEntryPoint
    private var isEditMode: Bool = false {
        didSet {
            if isEditMode {
                navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
                storeNameTextField.isEnabled = true
                storeURLTextField.isEnabled = true
                storeLocationTextField.isEnabled = true
                phoneNumberTextField.isEnabled = true
            } else {
                navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
                storeNameTextField.isEnabled = false
                storeURLTextField.isEnabled = false
                storeLocationTextField.isEnabled = false
                phoneNumberTextField.isEnabled = false
            }
        }
    }
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPage()
        keyboardDismisser()
    }
    
    init(from entryPoint: StoreProfilePageEntryPoint){
        self.entryPoint = entryPoint
        self.viewModel = StoreProfileVCViewModel.init()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        storeNameTextField.textfieldView.text = viewModel.fetchedData?.name
        storeURLTextField.textfieldView.text = viewModel.fetchedData?.URL
        storeLocationTextField.textfieldView.text = viewModel.fetchedData?.location.name
        phoneNumberTextField.textfieldView.text = viewModel.fetchedData?.phoneNumber
    }
    
    //TODO: error handling here
    private func viewModelDidError(){
        //handle error here
    }
    
    private func fetchData(){
        viewModel.fetchStoreProfile()
    }
    
}

//private function
private extension StoreProfileViewController {
    private func keyboardDismisser(){
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func saveTapped(){
        if validateTextField() {
            if let location = viewModel.fetchedLocation {
                let profile = StoreProfile(
                    name: storeNameTextField.textfieldView.text ?? "",
                    URL: storeURLTextField.textfieldView.text ?? "",
                    location: location,
                    phoneNumber: phoneNumberTextField.textfieldView.text ?? ""
                )
                viewModel.updateStoreProfile(profile)
                isEditMode = false
            }
        }
    }
    
    @objc private func editTapped(){
        isEditMode = true
    }
}

extension StoreProfileViewController: UITextFieldDelegate, GetLocationViewControllerDelegate {
    func selectLocationTo(_ location: SingleArea) {
        return
    }
    
    
    func selectLocationFrom(_ location: SingleArea) {
        storeLocationTextField.textfieldView.text = location.name
        viewModel.receiveStoreLocation(location: location)
    }
    
    private func setupPage(){
        bindToViewModel()
        setupTextField()
        
        switch entryPoint {
        case .onboarding:
            nextButton.isHidden = false
            titleLabel.isHidden = false
        case .settingPage:
            title = "Store Profile"
            viewModel.fetchStoreProfile()
            isEditMode = false
        case .onboardingExistingUser:
            break
        }
    }
    
    private func setupTextField(){
        storeNameTextField.textfieldView.delegate = self
        storeURLTextField.textfieldView.delegate = self
        storeLocationTextField.textfieldView.delegate = self
        phoneNumberTextField.textfieldView.delegate = self
        phoneNumberTextField.textfieldView.returnKeyType = .done
        storeNameTextField.textfieldData = Textfield(title: "Store Name", placeholder: "e.g. Store A")
        storeURLTextField.textfieldData = Textfield(title: "Store URL", placeholder: "https://")
        storeLocationTextField.textfieldData = Textfield(title: "Store Location", placeholder: "Store Address")
        storeLocationTextField.textfieldView.addTarget(self, action: #selector(getSellerLocation), for: .touchDown)
        phoneNumberTextField.textfieldData = Textfield(title: "Phone Number", placeholder: "+62")
    }
    
    @objc func getSellerLocation(){
        let vc = GetLocationViewController(from: .from)
        vc.modalPresentationStyle = .pageSheet
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.storeNameTextField.textfieldView:
            self.storeURLTextField.textfieldView.becomeFirstResponder()
        case self.storeURLTextField.textfieldView:
            self.storeLocationTextField.textfieldView.becomeFirstResponder()
        case self.storeLocationTextField.textfieldView:
            self.phoneNumberTextField.textfieldView.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
            print("insert done action")
        }
        return true
    }
    
    private func validateTextField() -> Bool {
        var errorCounter = 0
        
        let textField = [storeNameTextField, storeURLTextField, storeLocationTextField, phoneNumberTextField]
        
        textField.forEach({
            if ($0?.textfieldView.text ?? "").isEmpty {
                $0?.errorMessage = "\($0?.titleLabel.text ?? "") cannot be empty"
                errorCounter += 1
            } else {
                $0?.errorMessage = nil
            }
        })
        
        return errorCounter == 0 ? true : false
    }
    
    private func setupFirstTimeAutotext(){
        CoreDataManager.shared.saveDefaultAutotext(autotextData: Autotext(title: "Send Invoice", messages: "Berikut kami kirimkan detail pesanan serta total yang harus dibayar\n\nNama: #customerName\nNomor Telepon: #customerPhoneNumber\nAlamat Pengiriman: #customerAddress\nEkpedisi Pengiriman: #shippingExpedition\n\nProduk: \n#products\n\nTotal harga barang: #subTotalPrice\nOngkos kirim: #shippingPrice\nTotal yang harus dibayar: #totalPrice\n\nPesanan akan segera di proses setelah mengirimkan bukti pembayaran ya, kak.\n\nTerima kasih!"))
        CoreDataManager.shared.saveDefaultAutotext(autotextData: Autotext(title: "Format Order", messages: "Untuk melakukan pemesanan, mohon mengisi format order berikut\n\nNama:\nNomor Telepon:\n\nAlamat:\nKecamatan:\nKota:\nProvinsi:\nKode Pos:\n\nProduk yang dipesan:\n1.\n\nNote:\n\nEkspedisi Pengiriman:"))
        CoreDataManager.shared.saveCustomAutotext(autotextData: Autotext(title: "Selamat Datang", messages: "Hai selamat datang di #storeName. Ada yang bisa kami bantu?"))
        CoreDataManager.shared.saveCustomAutotext(autotextData: Autotext(title: "Reminder Pembayaran", messages: "Hi, jangan lupa untuk pengirimkan bukti pembayaran agar pesanan dapat segera di proses ya\n\nTerima kasih!"))
        CoreDataManager.shared.saveCustomAutotext(autotextData: Autotext(title: "Terima Kasih", messages: "Terima kasih telah memesan di #storeName. Jika berkenan mohon untuk memberikan ulasan mengenai produk kami.\n\nJangan lupa untuk kunjungi kami di #storeURL"))
    }
}

