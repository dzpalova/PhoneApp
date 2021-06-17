//
//  FavouriteCell.swift
//  PhoneApp
//
//  Created by Daniela Palova on 11.06.21.
//

import UIKit

class FavouriteCell: UITableViewCell {
    @IBOutlet var photo: UIImageView!
    @IBOutlet var photoCharacters: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var typeCallImage: UIImageView!
    @IBOutlet var typeCallLabel: UILabel!
    var imageNames = ["mobile": "phone.fill"]
    
    func setup(_ favourite: Favorite) {
        photoCharacters.text = favourite.contact!.getFullName().first?.uppercased()
        name.text = favourite.contact!.getFullName()
        typeCallLabel.text = favourite.typeCall
         typeCallImage = UIImageView(image: UIImage(named: imageNames["mobile"]!))
    }
}
