import UIKit

class InsertViewController: UIViewController {

    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var tfRelation: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnImagePicker: UIButton!
    
    let imagePicker = UIImagePickerController()
    var selectedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupImagePicker()
        setupTextFieldListeners()
    }
    
    func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        btnImagePicker.isEnabled = false
    }
    
    func setupTextFieldListeners() {
        [tfName, tfPhone, tfAddress, tfRelation].forEach { textField in
            textField?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    }
    
    @IBAction func btnImagePicker(_ sender: UIButton) {
        present(imagePicker, animated: true)
    }
    
    @IBAction func btnAdd(_ sender: UIButton) {
        guard let name = tfName.text, !name.isEmpty,
              let phone = tfPhone.text, !phone.isEmpty,
              let address = tfAddress.text, !address.isEmpty,
              let relation = tfRelation.text, !relation.isEmpty else {
            showAlert(message: "모든 필드를 입력해주세요.")
            return
        }
        
        insertUser(name: name, phone: phone, address: address, relationship: relation)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let allFieldsFilled = [tfName, tfPhone, tfAddress, tfRelation].allSatisfy { $0?.text?.isEmpty == false }
        btnImagePicker.isEnabled = allFieldsFilled
    }
    
    func insertUser(name: String, phone: String, address: String, relationship: String) {
        guard let url = URL(string: "http://127.0.0.1:8000/user/user_insert") else {
            showAlert(message: "Invalid URL")
            return
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = [
            URLQueryItem(name: "name", value: name),
            URLQueryItem(name: "phone", value: phone),
            URLQueryItem(name: "address", value: address),
            URLQueryItem(name: "relationship", value: relationship)
        ]
        
        guard let finalURL = components?.url else {
            showAlert(message: "URL 생성 실패")
            return
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] _, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.showAlert(message: "Error: \(error.localizedDescription)")
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    if let selectedImage = self?.selectedImage {
                        self?.uploadImage(image: selectedImage)
                    } else {
                        self?.showAlert(message: "연락처 추가 성공", isSuccess: true)
                    }
                } else {
                    self?.showAlert(message: "연락처 추가 실패")
                }
            }
        }
        
        task.resume()
    }
    
    func uploadImage(image: UIImage) {
        guard let url = URL(string: "http://127.0.0.1:8000/user/upload_image") else {
            showAlert(message: "Invalid URL")
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            showAlert(message: "이미지 변환 실패")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] _, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.showAlert(message: "이미지 업로드 실패: \(error.localizedDescription)")
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    self?.showAlert(message: "연락처 추가 및 이미지 업로드 성공", isSuccess: true)
                } else {
                    self?.showAlert(message: "이미지 업로드 실패")
                }
            }
        }
        
        task.resume()
    }
    
    func showAlert(message: String, isSuccess: Bool = false) {
        let alert = UIAlertController(title: isSuccess ? "성공" : "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            if isSuccess {
                self.navigationController?.popViewController(animated: true)
            }
        })
        present(alert, animated: true)
    }
}

extension InsertViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            imgView.image = pickedImage
            selectedImage = pickedImage
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
