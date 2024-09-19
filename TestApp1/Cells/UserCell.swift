//
//  UserCell.swift
//  TestApp2
//
//  Created by Raul Shafigin on 18.09.2024.
//

import UIKit
import TestApp1Framework

class UserCell: UITableViewCell {

    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImgView: UIImageView!
    
    override func prepareForReuse() {
        statusView.isHidden = true
        avatarImgView.image = nil
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    

}
