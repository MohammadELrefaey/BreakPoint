//
//  FeedCell.swift
//  BreakPoint
//
//  Created by Mohamed on 2/4/21.
//  Copyright © 2021 Refa3y. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var proflieImg: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
        
    //MARK:-  Methods
    func configure(profileImage: UIImage, email: String, content: String) {
        self.proflieImg.image = profileImage
        self.emailLbl.text = email
        self.contentLbl.text = content
    }

}
