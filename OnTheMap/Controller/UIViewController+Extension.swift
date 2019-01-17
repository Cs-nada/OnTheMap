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
        let alertVC = UIAlertController(title: "Action failed", message: "Invalid url provided by student", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}
