//
//  EntryVC.swift
//  BootcampBitirmeProjesi
//
//  Created by Erbil Can on 20.10.2023.
//

import UIKit
import Firebase

class EntryVC: UIViewController {

    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func buttonEntry(_ sender: Any) {
        if tfEmail.text != "" && tfPassword.text != ""{
            Auth.auth().signIn(withEmail: tfEmail.text!, password: tfPassword.text!){
                (AuthDataResult, error) in
                if error != nil{
                    self.hataMesaji(titleInput: "Hata!", messageInput: error?.localizedDescription ?? "Hata aldınız. Tekrar deneyiniz")
                }else{
                    self.performSegue(withIdentifier: "toTabBar", sender: nil)
                }
            }
        }
    }
    
    @IBAction func buttonSignup(_ sender: Any) {
        if tfEmail.text != "" && tfPassword.text != "" && tfUsername.text != "" {
            Auth.auth().createUser(withEmail: tfEmail.text!, password: tfPassword.text!){
                (AuthDataResult, error) in
                if error != nil {
                    self.hataMesaji(titleInput: "Hata", messageInput: error!.localizedDescription)
                }
                else{
                    let firestoreDatabase = Firestore.firestore()
                    let firestoreUser = ["userID" : Auth.auth().currentUser!.uid , "username" : self.tfUsername.text! , "email" : self.tfEmail.text! , "createDate" : FieldValue.serverTimestamp()] as [String : Any]
                    firestoreDatabase.collection("User").document(Auth.auth().currentUser!.uid).setData(firestoreUser) { (error) in
                        if error != nil{
                            self.hataMesaji(titleInput: "Hata", messageInput: error?.localizedDescription ?? "Hata Aldınız, Tekrar Deneyiniz")
                        }else{
                            self.tfUsername.text = ""
                            self.tfEmail.text = ""
                            self.tfPassword.text = ""
                        }
                    }
                    self.performSegue(withIdentifier: "toTabBar", sender: nil)
                }
            }
        }
    }
    func hataMesaji(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
       
    }
}
