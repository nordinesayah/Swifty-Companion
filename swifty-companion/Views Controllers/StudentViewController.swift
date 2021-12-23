//
//  StudentViewController.swift
//  swifty-companion
//
//  Created by Nordine Sayah on 05/12/2020.
//

import UIKit

class StudentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var userPicture: UIImageView!
    @IBOutlet weak var displayNameLbl: UILabel!
    @IBOutlet weak var loginLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var walletLbl: UILabel!
    @IBOutlet weak var correctionLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var levelLbl: UILabel!
    @IBOutlet weak var levelProgress: UIProgressView! {
        didSet {
            levelProgress.transform = levelProgress.transform.scaledBy(x: 1, y: 3)

        }
    }
    @IBOutlet weak var tableViewSkill: UITableView!
    @IBOutlet weak var tableViewProject: UITableView!
    
    var user: User?
    var coa: [Coalition]?
    var cursus: [(Int, String)] = []
    var cursus_id: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: (user?.imageUrl)!) {
            downloadImage(url: url)
        }
        userInfo()
    }
    
    func userInfo() {
        guard let user = user else {return }
        for curs in user.cursusUser
        {
            cursus.append((curs.cursus.id, curs.cursus.name))
        }
        displayNameLbl.text = user.displayname
        loginLbl.text = user.login
        phoneLbl.text = user.phone ?? "Unknown"
        emailLbl.text = user.email
        walletLbl.text = "\(user.wallet) ₳"
        correctionLbl.text = "\(user.correctionPoints)"
        if let location = user.location {
            locationLbl.text = "Available\n\(location)"
        } else {
            locationLbl.text = "Unavailable"
        }
        if let level = user.cursusUser.first?.level {
            levelLbl.text = floatToSring(level: level)
            levelProgress.progress = floatToPercent(level: level)
            if let coa = coa?.first {
                levelProgress.progressTintColor = coa.color.color
            }
        }
    }
    
    func floatToSring(level: Float) -> String {
        let levelString = String(level)
        let array = levelString.components(separatedBy: ".")
        let levelInt = array[0]
        var levelPercent = array[1]
        if levelPercent.count == 1 {
            levelPercent += "0"
        }
        
        return "Level \(levelInt) - \(levelPercent)%"
    }
    
    func floatToPercent(level: Float) -> Float {
        let x: Int = Int(level)
        let levelPercent = level - Float(x)
        return levelPercent
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) {
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                self.userPicture.image = UIImage(data: data)
                self.userPicture.layer.borderWidth = 2
                self.userPicture.layer.masksToBounds = false
                self.userPicture.layer.borderColor = UIColor.white.cgColor
                self.userPicture.layer.cornerRadius = self.userPicture.frame.size.width / 2
                self.userPicture.clipsToBounds = true
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int?
        
        if tableView == self.tableViewSkill {
            count = user?.cursusUser.first(where: { $0.cursus.id == cursus_id})?.skills.count
        }
        if tableView == self.tableViewProject {
            count = user?.projectsUser.filter { $0.cursus_ids.first == cursus_id && $0.status == "finished" && $0.project.parent_id == nil}.count
        }
        if (count == nil) {
            count = 0
        }
        return count!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell?
        
        if tableView == self.tableViewSkill {
            let scell = tableViewSkill.dequeueReusableCell(withIdentifier: "SkillCell") as! SkillTableViewCell
            if let skillSelected = user!.cursusUser.first(where: { $0.cursus.id == cursus_id}) {
                scell.skillLbl.text = "\(String(describing: skillSelected.skills[indexPath.row].name))"
                scell.skillLevelLbl.text = "level \(String(describing: skillSelected.skills[indexPath.row].level))"
                scell.skillProgress.progress = floatToPercent(level: (skillSelected.skills[indexPath.row].level))
                if let coa = self.coa?.first
                {
                    scell.skillProgress.progressTintColor = coa.color.color
                }
            cell = scell
            }
        }
        
        if tableView == self.tableViewProject {
            let pcell = tableViewProject.dequeueReusableCell(withIdentifier: "ProjectCell") as! ProjectTableViewCell
            let newArray = user!.projectsUser.filter { $0.cursus_ids.first == cursus_id && $0.status == "finished" && $0.project.parent_id == nil}

            pcell.projectNameLbl.text = newArray[indexPath.row].project.name
            if newArray[indexPath.row].validated == true {
                pcell.projectValidatedImg.image = UIImage(named: "checkmark")
            } else {
                pcell.projectValidatedImg.image = UIImage(named: "failed")
            }
            if (newArray[indexPath.row].final_mark != nil) {
                pcell.projectGradeLbl.text = String(describing: newArray[indexPath.row].final_mark!)
            } else {
                pcell.projectGradeLbl.text = "No grade"
            }
            cell = pcell
        }
        return cell!
    }
}

extension String {

var color: UIColor {
    let hex = trimmingCharacters(in: CharacterSet.alphanumerics.inverted)

    if #available(iOS 13, *) {
        guard let int = Scanner(string: hex).scanInt32(representation: .hexadecimal) else { return #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) }

        let a, r, g, b: Int32
        switch hex.count {
        case 3:     (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)  // RGB (12-bit)
        case 6:     (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)                    // RGB (24-bit)
        case 8:     (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)       // ARGB (32-bit)
        default:    (a, r, g, b) = (255, 0, 0, 0)
        }

        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 255.0)

    } else {
        var int = UInt32()

        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3:     (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)  // RGB (12-bit)
        case 6:     (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)                    // RGB (24-bit)
        case 8:     (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)       // ARGB (32-bit)
        default:    (a, r, g, b) = (255, 0, 0, 0)
        }

        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 255.0)
    }
  }
}
