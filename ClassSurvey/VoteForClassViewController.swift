//
//  VoteForClassViewController.swift
//  ClassSurvey
//
//  Created by Ashish Ashish on 11/4/21.
//

import UIKit
import Firebase

class VoteForClassViewController: UIViewController {

    var ref: DatabaseReference!

    
    var classInfo : ClassInfo?
    
    @IBOutlet weak var switchVote: UISwitch!
    @IBOutlet weak var lblClassTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

        lblClassTitle.text = "Class : \(String(describing: classInfo!.title))"

    }
    
    @IBAction func voteAction(_ sender: Any) {
        let uid = Auth.auth().currentUser?.uid
        let vote = switchVote.isOn
        
        ref.child("Votes").child(classInfo!.ID).child(uid!).setValue(["Vote": vote])
        updateClassVotes(vote)
        
    }
    
    func updateClassVotes(_ yes : Bool ){
        ref.child("Classes").child(classInfo!.ID).observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            var yesCount = value?["Yes"] as? Int ?? 0
            var noCount = value?["No"] as? Int ?? 0
            
            if yes == true {
                yesCount = yesCount + 1
            }else{
                noCount = noCount + 1
            }
            
            guard let classInfo = self.classInfo else {
                return
            }
 
            
            let info : [String: Any] = [    "Title": classInfo.title,
                                            "Yes": yesCount,
                                            "No": noCount
                                        ]
            
            self.ref.child("Classes").updateChildValues( [classInfo.ID  : info] )
            
            
        
            

        }) { error in
          print(error.localizedDescription)
        }
    }
    
    

}
