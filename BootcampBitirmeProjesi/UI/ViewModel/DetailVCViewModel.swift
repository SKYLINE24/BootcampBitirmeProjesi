//
//  DetailVCViewModel.swift
//  BootcampBitirmeProjesi
//
//  Created by Erbil Can on 21.10.2023.
//

import Foundation
import RxSwift
import UIKit

class DetailVCViewModel{
    var repo = FoodsDaoRepo()
    var orderQuantity = BehaviorSubject<Int>(value: 1)
    var totalPrice = BehaviorSubject<Int>(value: 1)
    var sepettekiYemekListesi = BehaviorSubject<[SepettekiYemekler]>(value: [SepettekiYemekler]())
    
    init(){
        orderQuantity = repo.orderQuantity
        totalPrice = repo.totalPrice
        sepettekiYemekListesi = repo.sepettekiYemekListesi
    }
    
    func addToCart(yemek_adi: String, yemek_resim_adi: String, yemek_fiyat: Int, yemek_siparis_adet: Int, kullanici_adi: String ){
        repo.addToCart(yemek_adi: yemek_adi, yemek_resim_adi: yemek_resim_adi, yemek_fiyat: yemek_fiyat, yemek_siparis_adet: yemek_siparis_adet, kullanici_adi: kullanici_adi)
    }
    
    func takePicOfFood(imageName: String) -> URL?{
        repo.takePicOfFood(imageName: imageName)
    }
    //MARK: detay sayfasında adet ayarlama
    func quantityCal(sender: UIButton){
        repo.quantityCal(sender: sender)
    }
    
    func calculateTotalPrice(price: Int){
        repo.calculateTotalPrice(price: price)
    }
    
    func uploadCart(kullanici_adi: String){
        repo.uploadCartList(kullanici_adi: kullanici_adi )
    }
    
    func deleteFromCart(sepet_yemek_id:Int, kullanici_adi:String){
        repo.deleteFromCart(sepet_yemek_id: sepet_yemek_id, kullanici_adi: "erbil")
    }
    
    func addAgainTocart(sepettekiListe : [SepettekiYemekler], yemek: Yemekler?, viewModel: DetailVCViewModel){
        var isName = false
        var y = SepettekiYemekler()
        for i in sepettekiListe{
            if let yemekAdi = i.yemek_adi{
                if yemekAdi == yemek!.yemek_adi{
                    isName = true
                    y = i
                    break
                } else {
                    isName = false
                }
            }
        }
        if isName {
            viewModel.deleteFromCart(sepet_yemek_id: Int(y.sepet_yemek_id!)! , kullanici_adi: "erbil")
            if let yemek = yemek{
                let intQuantity = (try? viewModel.orderQuantity.value()) ?? 1
                viewModel.addToCart(yemek_adi: yemek.yemek_adi ?? "yemek bulunamadı",yemek_resim_adi: yemek.yemek_resim_adi! ,yemek_fiyat: (Int((yemek.yemek_fiyat)!)! * (intQuantity + Int(y.yemek_siparis_adet!)!)) ,yemek_siparis_adet: intQuantity + Int(y.yemek_siparis_adet!)!,kullanici_adi: "erbil")
            }
        } else {
            if let yemek = yemek{
                let intQuantity = (try? viewModel.orderQuantity.value()) ?? 1
                viewModel.addToCart(yemek_adi: yemek.yemek_adi ?? "yemek bulunamadı",yemek_resim_adi: yemek.yemek_resim_adi! ,yemek_fiyat: (Int((yemek.yemek_fiyat)!)! * intQuantity) ,yemek_siparis_adet: intQuantity,kullanici_adi: "erbil")
            }
        }
    }
}
