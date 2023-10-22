//
//  DetailVC.swift
//  BootcampBitirmeProjesi
//
//  Created by Erbil Can on 18.10.2023.
//

import UIKit
import RxSwift

class DetailVC: UIViewController {
    
    @IBOutlet weak var imageLike: UIImageView!
    @IBOutlet weak var imageFood: UIImageView!
    @IBOutlet weak var labelFoodCost: UILabel!
    @IBOutlet weak var labelFoodName: UILabel!
    @IBOutlet weak var labelFoodNumber: UILabel!
    @IBOutlet weak var labelFoodTotalCost: UILabel!
    
    var viewModel = DetailVCViewModel()
    var yemek: Yemekler?
    var sepettekiListe = [SepettekiYemekler]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.uploadCart(kullanici_adi: "erbil")
        _ = viewModel.sepettekiYemekListesi.subscribe(onNext: { liste in
            self.sepettekiListe = liste
        })
        
        if let y = yemek{
            
            _ = viewModel.totalPrice.subscribe(onNext: { price in
                self.labelFoodTotalCost.text = "₺ \(price),00"
            })
            _ = viewModel.orderQuantity.subscribe(onNext: { q in
                self.labelFoodNumber.text = "\(q)"
            })
            labelFoodName.text = y.yemek_adi
            labelFoodCost.text = "₺ \(y.yemek_fiyat!),00"
            labelFoodTotalCost.text = "₺ \(y.yemek_fiyat!),00"
            
            let imageURL = viewModel.takePicOfFood(imageName: (y.yemek_resim_adi!))
            if let url = imageURL {
                DispatchQueue.main.async{
                    self.imageFood.kf.setImage(with: url)
                }
            }
        }
    }
    @IBAction func orderQuantityButton(_ sender: UIButton) {
        viewModel.quantityCal(sender: sender)
        viewModel.calculateTotalPrice(price: Int((yemek?.yemek_fiyat)!)!)
    }
    
    @IBAction func buttonAddBasket(_ sender: Any) {
        viewModel.addAgainTocart(sepettekiListe: sepettekiListe, yemek: yemek, viewModel: viewModel)
        dismiss(animated: true)
    }
    
}
