//
//  ProjectTableViewCell.swift
//  swifty-companion
//
//  Created by Nordine Sayah on 05/12/2020.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {

    @IBOutlet weak var projectNameLbl: UILabel!
    @IBOutlet weak var projectGradeLbl: UILabel!
    @IBOutlet weak var projectValidatedImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
