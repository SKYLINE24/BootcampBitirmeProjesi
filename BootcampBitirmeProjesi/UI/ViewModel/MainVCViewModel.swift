//
//  MainVCViewModel.swift
//  BootcampBitirmeProjesi
//
//  Created by Erbil Can on 19.10.2023.
//

import Foundation
import RxSwift

class MainVCViewModel{
    var repo = FoodsDaoRepo()
    var yemekListesi = BehaviorSubject<[Yemekler]>(value: [Yemekler]())
    var orderQuantity   = BehaviorSubject<Int>(value: 1)
    var sepettekiYemekListesi = BehaviorSubject<[SepettekiYemekler]>(value: [SepettekiYemekler]())
    
    init(){
        yemekListesi = repo.yemekListesi
        orderQuantity = repo.orderQuantity
        sepettekiYemekListesi = repo.sepettekiYemekListesi
    }
    func uploadFoodList(){
        repo.uploadFoodList()
    }
    func addToCart(yemek_adi: String, yemek_resim_adi: String, yemek_fiyat: Int, yemek_siparis_adet: Int, kullanici_adi: String ){
        repo.addToCart(yemek_adi: yemek_adi,yemek_resim_adi: yemek_resim_adi,yemek_fiyat: yemek_fiyat,yemek_siparis_adet: yemek_siparis_adet,kullanici_adi: kullanici_adi)
    }
    
    func uploadCart(kullanici_adi: String){
        repo.uploadCartList(kullanici_adi: kullanici_adi )
    }
    
    func takePicOfFood(imageName: String) -> URL?{
        return repo.takePicOfFood(imageName: imageName)
    }
    
    func deleteFromCart(sepet_yemek_id: Int, kullanici_adi: String){
        repo.deleteFromCart(sepet_yemek_id: sepet_yemek_id, kullanici_adi: kullanici_adi)
    }
    //ürün tekrar ekleme işlemi
    func addAgainTocart(sepettekiListe : [SepettekiYemekler], yemek: Yemekler?, viewModel: MainVCViewModel){
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
        if isName { //var olan ürünü sil yeninisi yükle
            viewModel.deleteFromCart(sepet_yemek_id: Int(y.sepet_yemek_id!)! , kullanici_adi: "erbil")
            if let yemek = yemek{
                viewModel.addToCart(yemek_adi: yemek.yemek_adi ?? "yemek bulunamadı",yemek_resim_adi: yemek.yemek_resim_adi! ,yemek_fiyat: (Int((yemek.yemek_fiyat)!)! * (1 + Int(y.yemek_siparis_adet!)!)) ,yemek_siparis_adet: 1 + Int(y.yemek_siparis_adet!)!,kullanici_adi: "erbil")
            }
        } else {
            if let yemek = yemek{
                let intQuantity = (try? viewModel.orderQuantity.value()) ?? 1
                viewModel.addToCart(yemek_adi: yemek.yemek_adi!,yemek_resim_adi: yemek.yemek_resim_adi! ,yemek_fiyat: (Int((yemek.yemek_fiyat)!)! * intQuantity) ,yemek_siparis_adet: intQuantity,kullanici_adi: "erbil")
            }
        }
    }
}
