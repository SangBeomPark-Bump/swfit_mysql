//
//  TableViewController.swift
//  testProject
//
//  Created by TJ on 2024/12/18.
//

import UIKit

class TableViewController: UITableViewController {
    @IBOutlet var tvListView: UITableView!
    var data: [DBJson] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchData()  // 서버에서 데이터 가져오기
            }

            // MARK: - 데이터 가져오기

            func fetchData() {
                let urlString = "http://127.0.0.1:8000/user/user_select"
                guard let url = URL(string: urlString) else { return }

                let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                        return
                    }

                    guard let data = data else { return }

                    do {
                        // 서버에서 반환된 JSON을 배열로 디코딩
                        let decoder = JSONDecoder()
                        let response = try decoder.decode([DBJson].self, from: data)

                        // 서버 응답에서 데이터 추출
                        self?.data = response
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()  // 데이터 갱신 후 테이블 뷰 새로고침
                        }
                    } catch {
                        print("Error decoding data: \(error)")
                    }
                }
                task.resume()
            }

            // MARK: - Table view data source

            override func numberOfSections(in tableView: UITableView) -> Int {
                return 1
            }

            override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return data.count
            }

            override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! TableViewCell

                let imageData = data[indexPath.row]

                // 이미지 Base64 디코딩
                if let imageString = imageData.image,
                   let imageDataDecoded = Data(base64Encoded: imageString, options: .ignoreUnknownCharacters) {
                    cell.imgCell?.image = UIImage(data: imageDataDecoded)
                }

                // 이름과 전화번호 설정
                cell.nameCell.text = imageData.name
                cell.phoneCell.text = imageData.phone

                return cell
            }
        }
