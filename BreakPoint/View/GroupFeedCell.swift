//
//  GroupFeedCell.swift
//  BreakPoint
//
//  Created by Mohamed on 3/6/21.
//  Copyright © 2021 Refa3y. All rights reserved.
//

import UIKit

class GroupFeedCell: UITableViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    
    //MARK:- Methods
    func configure(image: UIImage, email: String, content: String) {
        profileImage.image = image
        emailLbl.text = email
        contentLbl.text = content
    }
}
