//
//  SkillTableViewCell.swift
//  swifty-companion
//
//  Created by Nordine Sayah on 05/12/2020.
//

import UIKit

class SkillTableViewCell: UITableViewCell {

    @IBOutlet weak var skillLbl: UILabel!
    @IBOutlet weak var skillLevelLbl: UILabel!
    @IBOutlet weak var skillProgress: UIProgressView! {
        didSet {
            skillProgress.transform = skillProgress.transform.scaledBy(x: 1, y: 1.5)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
