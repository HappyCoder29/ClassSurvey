//
//  DashboardViewController.swift
//  ClassSurvey
//
//  Created by Ashish Ashish on 11/4/21.
//

import UIKit
import Firebase

class DashboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var ref: DatabaseReference!
    var classes: [ClassInfo] = [ClassInfo]()
    var classInfo: ClassInfo?

    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        loadClassInfo()

    }
    
    @IBAction func logoutAction(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            Keychain().key.clear()
            self.navigationController?.popViewController(animated: true)
            
        }catch{
            print(error.localizedDescription)
        }
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let info = classes[indexPath.row]
        cell.textLabel?.text = "\(info.title)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        classInfo = classes[indexPath.row]
        performSegue(withIdentifier: "voteForClassSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "voteForClassSegue"{
            let detailsVC = segue.destination as! VoteForClassViewController
            detailsVC.classInfo = classInfo
        }
    }
    
    func loadClassInfo(){
        classes.removeAll()
        ref.child("Classes").observeSingleEvent(of: .value) { snapShot in
            
            for child in snapShot.children {
                let ch = child as! DataSnapshot
                let classInfo = ClassInfo()
                classInfo.ID = ch.key
                let val = ch.value as! [String : Any]
                classInfo.title = val["Title"] as! String
                classInfo.yes = val["Yes"] as! Int
                classInfo.no = val["No"] as! Int
                
                self.classes.append(classInfo)
                
            }
            self.tblView.reloadData()
            
            
        }
        
    }
    
}
