import UIKit

class UpdateDeleteViewController: UIViewController {
    
    let imagePicker = UIImagePickerController()
    var curAddress: Address?
    var selectedImage: UIImage?

    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var tfRelation: UITextField!
    @IBOutlet weak var tfImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupImagePicker()
    }
    
    func setupUI() {
        tfName.text = curAddress?.name
        tfPhone.text = curAddress?.phoneNumber
        tfAddress.text = curAddress?.address
        tfRelation.text = curAddress?.relation
        tfImage.image = curAddress?.photo
    }
    
    func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
    }
    
    @IBAction func btnChangeImage(_ sender: UIButton) {
        present(imagePicker, animated: true)
    }
    
    @IBAction func btnUpdate(_ sender: UIButton) {
        guard let id = curAddress?.id,
              let name = tfName.text, !name.isEmpty,
              let phone = tfPhone.text, !phone.isEmpty,
              let address = tfAddress.text, !address.isEmpty,
              let relation = tfRelation.text, !relation.isEmpty else {
            showAlert(message: "모든 필드를 입력해주세요.")
            return
        }
        
        let imageToUpdate = selectedImage ?? curAddress?.photo
        updateUser(seq: id, name: name, phone: phone, address: address, relationship: relation, image: imageToUpdate)
    }
    
    func updateUser(seq: Int, name: String, phone: String, address: String, relationship: String, image: UIImage?) {
        guard let url = URL(string: "http://127.0.0.1:8000/user/user_update") else {
            showAlert(message: "Invalid URL")
            return
        }
        
        guard let imageData = image?.jpegData(compressionQuality: 0.8) else {
            showAlert(message: "이미지 변환 실패")
            return
        }
        
        let base64Image = imageData.base64EncodedString()
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = [
            URLQueryItem(name: "seq", value: String(seq)),
            URLQueryItem(name: "name", value: name),
            URLQueryItem(name: "phone", value: phone),
            URLQueryItem(name: "address", value: address),
            URLQueryItem(name: "relationship", value: relationship),
            URLQueryItem(name: "image", value: base64Image)
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
                    self?.showAlert(message: "업데이트 성공", isSuccess: true)
                } else {
                    self?.showAlert(message: "업데이트 실패")
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

extension UpdateDeleteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            tfImage.image = pickedImage
            selectedImage = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
