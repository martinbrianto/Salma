//
//  EnableKeyboardViewController.swift
//  Salma
//
//  Created by gratianus.brianto on 26/04/22.
//

import UIKit

class EnableKeyboardViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBAction func openPreferencesAction(_ sender: Any) {
        print("insert Open Preferences Action")
        if let url = URL.init(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func skipButtonAction(_ sender: Any) {
        print("insert Skip Action")
        let vc = TabBarViewController()
        setupFirstTimeAutotext()
        UserDefaults.standard.set(true, forKey: "didFirstLaunch")
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }

    // MARK: - Variables
    private var entryPoint: StoreProfilePageEntryPoint
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Enable Keyboard"
        setupPage()
    }
    
    init(from entryPoint: StoreProfilePageEntryPoint){
        self.entryPoint = entryPoint
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension EnableKeyboardViewController {
    private func setupPage(){
        switch entryPoint {
        case .onboarding:
            skipButton.isHidden = false
            titleLabel.isHidden = true
        case .settingPage:
            break
        }
    }
    
    private func setupFirstTimeAutotext(){
        CoreDataManager.shared.saveDefaultAutotext(autotextData: Autotext(title: "Send Invoice", messages: "Berikut kami kirimkan detail pesanan serta total yang harus dibayar\n\nNama: #customerName\nNomor Telepon: #customerPhoneNumber\nAlamat Pengiriman: #customerAddress\nEkpedisi Pengiriman: #shippingExpedition\n\nProduk: \n#products\n\nTotal harga barang: #subTotalPrice\nOngkos kirim: #shippingPrice\nTotal yang harus dibayar: #totalPrice\n\nPesanan akan segera di proses setelah mengirimkan bukti pembayaran ya, kak.\n\nTerima kasih!"))
        CoreDataManager.shared.saveDefaultAutotext(autotextData: Autotext(title: "Format Order", messages: "Untuk melakukan pemesanan, mohon mengisi format order berikut\n\nNama:\nNomor Telepon:\n\nAlamat:\nKecamatan:\nKota:\nProvinsi:\nKode Pos:\n\nProduk yang dipesan:\n1.\n\nNote:\n\nEkspedisi Pengiriman:"))
        CoreDataManager.shared.saveCustomAutotext(autotextData: Autotext(title: "Selamat Datang", messages: "Hai selamat datang di #storeName. Ada yang bisa kami bantu?"))
        CoreDataManager.shared.saveCustomAutotext(autotextData: Autotext(title: "Reminder Pembayaran", messages: "Hi, jangan lupa untuk pengirimkan bukti pembayaran agar pesanan dapat segera di proses ya\n\nTerima kasih!"))
        CoreDataManager.shared.saveCustomAutotext(autotextData: Autotext(title: "Terima Kasih", messages: "Terima kasih telah memesan di #storeName. Jika berkenan mohon untuk memberikan ulasan mengenai produk kami.\n\nJangan lupa untuk kunjungi kami di #storeURL"))
    }
}
