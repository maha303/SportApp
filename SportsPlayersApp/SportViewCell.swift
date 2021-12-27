//
//  SportViewCell.swift
//  SportsPlayersApp
//
//  Created by Maha saad on 23/05/1443 AH.
//

import UIKit

class SportViewCell: UITableViewCell {

    @IBOutlet weak var sportImage: UIImageView!
    @IBOutlet weak var sportNameLabel: UILabel!
    
    weak var cellDelegate:CellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
                sportImage.isUserInteractionEnabled = true
                sportImage.addGestureRecognizer(tapGR)
     
    }
    @objc func imageTapped(_ sender: UITapGestureRecognizer){
           cellDelegate?.changeImage(self)
       }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
