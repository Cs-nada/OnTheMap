//
//  UIViewController+Extension.swift
//

import UIKit

extension UIViewController {
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        LoginClient.logout {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
