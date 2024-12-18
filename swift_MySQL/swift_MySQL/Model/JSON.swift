//
//  JSON.swift
//  mySQL_image_address_project
//
//  Created by changbin an on 12/18/24.
//

import Foundation
//import UIKit

struct MainJson : Codable {
    //// json의 변수 이름과 key 값을 똑같이 해줘야함
    var seq: Int?
    var name: String
    var phone: String
    var address : String
    var relationship: String
    var image : String?
}
