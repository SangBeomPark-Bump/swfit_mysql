//
//  ViewAddController.swift
//  testProject
//
//  Created by TJ on 2024/12/18.
//

import UIKit

class ViewAddController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var tfname: UITextField!
    @IBOutlet weak var tfphone: UITextField!
    @IBOutlet weak var tfaddress: UITextField!
    @IBOutlet weak var tfrelation: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    var selectedImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func btnImageAdd(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func btnAdd(_ sender: UIButton) {
        guard let selectedImage = self.selectedImage else {
                    print("No image selected")
                    return
                }
                
                // 이미지를 Base64로 인코딩
                if let imageData = selectedImage.jpegData(compressionQuality: 1.0) {
                    let base64String = imageData.base64EncodedString()
                    uploadImage(base64String: base64String)
                }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            self.selectedImage = selectedImage
            imgView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func uploadImage(base64String: String) {
        let url = URL(string: "http://127.0.0.1:8000/user/upload_image")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let params: [String: Any] = [
            "name": "John Doe",   // 이름, 전화번호 등의 다른 필드도 추가 가능
            "phone": "123-4567",
            "address": "123 Main St",
            "relationship": "Friend",
            "image": base64String
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            request.httpBody = jsonData
        } catch {
            print("Error encoding data: \(error)")
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            // 서버의 응답 처리
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode([String: String].self, from: data)
                print(response) // 서버의 응답을 출력
            } catch {
                print("Error decoding response: \(error)")
            }
        }
        task.resume()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//            // 선택된 이미지 가져오기
//            if let selectedImage = info[.originalImage] as? UIImage {
//                // 이미지 뷰에 선택된 이미지 설정
//                imgView.image = selectedImage
//            }
//
//            // 이미지 피커 화면 닫기
//            dismiss(animated: true, completion: nil)
//        }
//
//        // 이미지 선택을 취소했을 때 호출되는 델리게이트 메서드
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            // 이미지 피커 화면 닫기
//            dismiss(animated: true, completion: nil)
//        }

}
