//
//  Address.swift
//  swift_MySQL
//
//  Created by BUMPIE on 12/18/24.
//

import UIKit

struct Address{
    var id: Int?
    var name: String
    var phoneNumber: String
    var address : String
    var relation: String
    var photo : UIImage
    
    init(id: Int? = nil, name: String, phoneNumber: String, address: String, relation: String, photo: UIImage) {
        self.id = id
        self.name = name
        self.phoneNumber = phoneNumber
        self.address = address
        self.relation = relation
        self.photo = photo
    }
}
