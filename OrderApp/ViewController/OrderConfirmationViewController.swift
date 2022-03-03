//
//  OrderConfirmationViewController.swift
//  OrderApp
//
//  Created by Qnarik Davtyan on 16.02.22.
//

import UIKit

class OrderConfirmationViewController: UIViewController {
    // MARK: - Outlet
    
    @IBOutlet var confirmationLabel: UILabel!
    
    let minutesToPrepare: Int

    // MARK: - Init
    
    init?(coder: NSCoder, minutesToPrepare: Int) {
        self.minutesToPrepare = minutesToPrepare
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        confirmationLabel.text = "Thank you for your order! Your wait time is approximately \(minutesToPrepare) minutes."
    }
  
}
