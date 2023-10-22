//
//  ViewController.swift
//  BootcampBitirmeProjesi
//
//  Created by Erbil Can on 12.10.2023.
//
//MARK: IMPORT

import UIKit
import RxSwift
import Kingfisher

//MARK: CLASS

class MainVC: UIViewController {

    @IBOutlet weak var foodsTableView: UITableView!
    
    var foodsList = [Yemekler]()
    
    var viewModel = MainVCViewModel()
    var yemekListesi    = [Yemekler]()
    var sepettekiListe  = [SepettekiYemekler]()
    override func viewDidLoad() {
        super.viewDidLoad()
        foodsTableView.delegate = self
        foodsTableView.dataSource = self
        
        _ = viewModel.yemekListesi.subscribe(onNext: { list in
            self.yemekListesi = list
            self.foodsTableView.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.uploadFoodList()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetayVC"{
            if let yemek = sender as? Yemekler{
                let toVC = segue.destination as! DetailVC
                toVC.yemek = yemek
            }
        }
    }
}
//MARK: EXTENSİONS

extension MainVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yemekListesi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodsCell", for: indexPath) as! FoodsCell
        let food = yemekListesi[indexPath.row]
        
        cell.labelFoodName.text = food.yemek_adi
        cell.labelFoodCost.text = "₺ \(food.yemek_fiyat!),00"
        let imageURL = viewModel.takePicOfFood(imageName: food.yemek_resim_adi!)
        if let url = imageURL {
            DispatchQueue.main.async {
                cell.imageFood.kf.setImage(with: url)
            }
        }
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let yemek = yemekListesi[indexPath.row]
        performSegue(withIdentifier: "toDetayVC", sender: yemek)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
