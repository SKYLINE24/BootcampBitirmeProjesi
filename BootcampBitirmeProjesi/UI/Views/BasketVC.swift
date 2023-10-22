//
//  BasketVC.swift
//  BootcampBitirmeProjesi
//
//  Created by Erbil Can on 18.10.2023.
//

import UIKit
import RxSwift
import Kingfisher

class BasketVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelFoodsTotalCost: UILabel!
    
    var viewModel = BasketVCViewModel()
    var sepettekiListe = [SepettekiYemekler]()
    
    override func viewDidLoad() {
        tableView.delegate   = self
        tableView.dataSource = self
        
        _ = viewModel.sepettekiYemekListesi.subscribe(onNext: { liste in
            self.sepettekiListe = liste.sorted(by: { $0.yemek_adi! < $1.yemek_adi! })
            self.setBadge()
            self.tableView.reloadData()
        })
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        uploadCartView()
        NotificationCenter.default.addObserver(self, selector: #selector(itemDeleted(notification:)), name: Notification.Name("ItemDeleted"), object: nil)
    }
    
    func uploadCartView(){
        viewModel.uploadCartList(kullanici_adi: "erbil")
        setBadge()
    }
    
    func setBadge(){
        viewModel.setBadge(sepettekiListe: sepettekiListe, tabBarItem: tabBarItem)
        setTotalCartPrice()
    }
    
    func setTotalCartPrice(){
        labelFoodsTotalCost.text = "₺ \(viewModel.setTotalCartPrice(sepettekiListe: sepettekiListe)),00"
    }
    
    
    @objc func itemDeleted(notification: Notification){
        uploadCartView()
        
    }
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
}

//MARK: EXTENSİONS

extension BasketVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sepettekiListe.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasketCell", for: indexPath) as! BasketCell
        
        let food = sepettekiListe[indexPath.row]
        
        cell.labelFoodName.text = food.yemek_adi
        let imageURL = viewModel.takePicOfFood(imageName: food.yemek_resim_adi!)
        if let url = imageURL{
            DispatchQueue.main.async {
                cell.imageFoodImage.kf.setImage(with: url)
            }
        }
        cell.labelFoodCost.text = "₺ \(food.yemek_fiyat!),00"
        cell.labelFoodNumber.text = " \(food.yemek_siparis_adet!) Adet"
        cell.yemek = food
        cell.selectionStyle = .none
        
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let food = sepettekiListe[indexPath.row]
            sepettekiListe.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            viewModel.deleteFromCart(sepet_yemek_id: Int(food.sepet_yemek_id!)!, kullanici_adi: "erbil")
            setBadge()
        }
    }
    
    @objc func deleteItem(sender: UIButton) {
        let indexP = IndexPath(row: sender.tag, section: 0)
        let yemek = sepettekiListe[indexP.row]
        if let intID = Int(yemek.sepet_yemek_id!) {
            viewModel.deleteFromCart(sepet_yemek_id: intID, kullanici_adi: "erbil")
            sepettekiListe.remove(at: indexP.row)
            tableView.deleteRows(at: [indexP], with: .fade)
            NotificationCenter.default.post(name: Notification.Name("CartItemDeleted"), object: nil)
        }
    }
    
}
