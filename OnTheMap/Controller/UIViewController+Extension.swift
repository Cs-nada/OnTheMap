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
    
    func showUrlFailure() {
        showErrorMessage("Action failed", msg: "Invalid url provided by student")
    }
    
    func showErrorMessage(_ title: String, msg: String) {
        let alertVC = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}
