//
//  BasketVCViewModel.swift
//  BootcampBitirmeProjesi
//
//  Created by Erbil Can on 21.10.2023.
//

import Foundation
import RxSwift
import UIKit

class BasketVCViewModel{
    var repo = FoodsDaoRepo()
    var sepettekiYemekListesi = BehaviorSubject<[SepettekiYemekler]>(value: [SepettekiYemekler]())
    var orderQuantity = BehaviorSubject<Int>(value: 1)
    var totalPrice = BehaviorSubject<Int>(value: 1)
    var listCount = 0
    
    init(){
        sepettekiYemekListesi = repo.sepettekiYemekListesi
        orderQuantity = repo.orderQuantity
        totalPrice = repo.totalPrice
    }
    
    func uploadCartList(kullanici_adi: String){
        repo.uploadCartList(kullanici_adi: kullanici_adi)
    }
    
    func deleteFromCart(sepet_yemek_id:Int, kullanici_adi: String){
        repo.deleteFromCart(sepet_yemek_id: sepet_yemek_id, kullanici_adi: kullanici_adi)
    }
    
    func takePicOfFood(imageName: String) -> URL?{
        repo.takePicOfFood(imageName: imageName)
    }
    
    func addToCart(yemek_adi: String, yemek_resim_adi: String, yemek_fiyat: Int, yemek_siparis_adet: Int, kullanici_adi: String ){
        repo.addToCart(yemek_adi:yemek_adi, yemek_resim_adi:yemek_resim_adi,yemek_fiyat:yemek_fiyat,yemek_siparis_adet:yemek_siparis_adet,kullanici_adi:kullanici_adi)
    }
    
    func setBadge(sepettekiListe: [SepettekiYemekler], tabBarItem: UITabBarItem){
        listCount = sepettekiListe.count
        tabBarItem.badgeValue = listCount > 0 ? "\(listCount)" : nil
    }
    
    func setTotalCartPrice(sepettekiListe: [SepettekiYemekler]) -> Int{
        var totalPrice = 0
        for i in sepettekiListe{
            totalPrice += Int(i.yemek_fiyat!)!
        }
        return totalPrice
    }
}
