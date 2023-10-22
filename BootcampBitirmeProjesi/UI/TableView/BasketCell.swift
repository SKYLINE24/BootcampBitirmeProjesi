//
//  BasketCell.swift
//  BootcampBitirmeProjesi
//
//  Created by Erbil Can on 21.10.2023.
//

import UIKit

class BasketCell: UITableViewCell {
    @IBOutlet weak var imageFoodImage: UIImageView!
    @IBOutlet weak var labelFoodName: UILabel!
    @IBOutlet weak var labelFoodCost: UILabel!
    @IBOutlet weak var labelFoodNumber: UILabel!
    @IBOutlet weak var labelFoodTotalCost: UILabel!
    
    var yemek = SepettekiYemekler()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
