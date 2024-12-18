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
    
    @IBAction func btnUpdate(_ sender: UIButton) {
        updateUser(
            seq: curAddress!.id!,
            name: tfName.text!,
            phone: tfPhone.text!,
            address: tfAddress.text!,
            relationship: tfRelation.text!,
            image: curAddress!.photo
        )
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    func updateUser(seq: Int, name: String, phone: String, address: String, relationship: String, image: UIImage) {
        // 1. URL 설정
        guard let url = URL(string: "http://127.0.0.1:8000/user/user_update") else { return }
        
        // 2. 이미지를 base64 문자열로 변환
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        let base64Image = imageData.base64EncodedString()
        
        // 3. 쿼리 파라미터 설정
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = [
            URLQueryItem(name: "seq", value: String(seq)),
            URLQueryItem(name: "name", value: name),
            URLQueryItem(name: "phone", value: phone),
            URLQueryItem(name: "address", value: address),
            URLQueryItem(name: "relationship", value: relationship),
            URLQueryItem(name: "image", value: base64Image)
        ]
        
        guard let finalURL = components?.url else { return }
        
        // 4. URLRequest 생성
        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"
        
        // 5. URLSession을 사용하여 요청 전송
        let task = URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("Request sent successfully")
            }
        }
        
        task.resume()
    }

    
    
    
    
}




extension UpdateDeleteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            tfImage.image = pickedImage // 선택한 이미지를 UIImageView에 표시
            curAddress!.photo = pickedImage
        }
        dismiss(animated: true, completion: nil) // 이미지 선택창 닫기
    }


    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil) // 취소 시 창 닫기
    }
}
