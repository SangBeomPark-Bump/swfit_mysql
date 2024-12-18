//
//  UpdateDeleteViewController.swift
//  swift_MySQL
//
//  Created by BUMPIE on 12/18/24.
//

import UIKit

class UpdateDeleteViewController: UIViewController {
    
    let imagePicker = UIImagePickerController()

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

        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnChangeImage(_ sender: UIButton) {
        present(imagePicker, animated: true)
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

extension UpdateDeleteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            tfImage.image = pickedImage // 선택한 이미지를 UIImageView에 표시
        }
        dismiss(animated: true, completion: nil) // 이미지 선택창 닫기
    }


    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil) // 취소 시 창 닫기
    }
}


extension UpdateDeleteViewController: MainUpdateModelProtocol {
    func contactUpdated(success: Bool, message: String) {
        DispatchQueue.main.async {
            let title = success ? "Success" : "Error"
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
