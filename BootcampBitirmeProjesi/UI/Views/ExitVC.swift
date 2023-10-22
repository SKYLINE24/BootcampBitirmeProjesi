//
//  ExitVC.swift
//  BootcampBitirmeProjesi
//
//  Created by Erbil Can on 20.10.2023.
//

import UIKit
import Firebase

class ExitVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func buttonExit(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toEntry", sender: nil)
        }catch{
            print("Hata")
        }
    }
    
    func mesajGoster(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
