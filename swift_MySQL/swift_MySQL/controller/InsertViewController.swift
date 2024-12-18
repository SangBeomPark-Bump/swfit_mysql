//
//  InsertViewController.swift
//  swift_MySQL
//
//  Created by BUMPIE on 12/18/24.
//

import UIKit

class InsertViewController: UIViewController {

    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var tfRelation: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var btnImagePicker: UIButton!
    
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        btnImagePicker.isEnabled = false
        // 텍스트 필드의 변경 이벤트 감지
        tfName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @IBAction func btnImagePicker(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func btnAdd(_ sender: UIButton) {
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
           // 텍스트가 비어 있지 않으면 버튼 활성화
        if let text = tfName.text, !text.isEmpty {
               btnImagePicker.isEnabled = true
           } else {
               btnImagePicker.isEnabled = false
           }
       }
}

extension InsertViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            imgView.image = pickedImage // 선택한 이미지를 UIImageView에 표시
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil) // 취소 시 창 닫기
    }
}
