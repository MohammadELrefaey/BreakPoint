//
//  GroupCell.swift
//  BreakPoint
//
//  Created by Mohamed on 3/5/21.
//  Copyright © 2021 Refa3y. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var membersCountLbl: UILabel!

    //MARK:- Methods
    func configure(title: String, description: String, membersCount: Int) {
        titleLbl.text = title
        descriptionLbl.text = description
        membersCountLbl.text = "\(membersCount) members."
    }
}
