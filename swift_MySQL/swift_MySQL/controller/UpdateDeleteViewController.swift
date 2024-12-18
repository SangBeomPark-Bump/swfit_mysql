//
//  UpdateDeleteViewController.swift
//  swift_MySQL
//
//  Created by BUMPIE on 12/18/24.
//

import UIKit

class UpdateDeleteViewController: UIViewController {
    
    var curAddress : Address?

    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var tfRelation: UITextField!
    
    @IBOutlet weak var tfImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfName.text =  curAddress!.name
        tfPhone.text = curAddress!.phoneNumber
        tfAddress.text = curAddress!.address
        tfRelation.text = curAddress!.relation
        
        tfImage.image = curAddress!.photo

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
