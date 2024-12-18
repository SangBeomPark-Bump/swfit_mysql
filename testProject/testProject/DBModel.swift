//
//  DBModel.swift
//  testProject
//
//  Created by TJ on 2024/12/18.
//

import Foundation

struct MyData: Decodable{
    var name: String
    var phone: String
    var image: String?
    
    init(name: String, phone: String, image: String? = nil) {
        self.name = name
        self.phone = phone
        self.image = image
    }
    

}
