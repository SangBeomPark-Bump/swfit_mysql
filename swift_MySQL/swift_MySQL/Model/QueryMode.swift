//
//  QueryMode.swift
//  swift_MySQL
//
//  Created by changbin an on 12/18/24.
//

import Foundation
import UIKit
/// 여기부터
protocol MainQueryModelProtocol {
    func itemDownloaded(items: [Address])
}

class QueryModel{
    var delegate: MainQueryModelProtocol!
    let urlPath = "http://127.0.0.1:8000/user/user_select"
    
    func downloadItems()async{
        let url = URL(string: urlPath)!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            await parseJSON(data)
        } catch {
            print("Failed to download data : \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func parseJSON(_ data: Data)async{
        
        let decoder = JSONDecoder()
        var locations : [Address] = []
        do{
            let addresses = try decoder.decode([MainJson].self, from : data)
            for address in addresses{
                let query = Address(name: address.name, phoneNumber: address.phone, address: address.address, relation: address.relationship, photo: UIImage(named: "lamp_on")!)
                locations.append(query)
            }
            
        } catch{
            do{
//                print(data)
                try decoder.decode([MainJson].self, from : data)
//                print(addresses)
//                for address in addresses{
//                    let query = Address(name: address.name, phoneNumber: address.phone, address: address.address, relation: address.relationship, photo: UIImage(named: "lamp_on")!)
//                    locations.append(query)
//                }
                
            } catch{
                print("Failed : \(error.localizedDescription)")
            }
            print("Failed : \(error.localizedDescription)")
        }
        self.delegate.itemDownloaded(items: locations)
    }
    
}/// MainQueryModel


