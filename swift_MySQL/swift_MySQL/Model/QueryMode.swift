//
//  QueryMode.swift
//  swift_MySQL
//
//  Created by changbin an on 12/18/24.
//

import Foundation

/// 여기부터
protocol MainQueryModelProtocol {
    func itemDownloaded(items: [DBModelMain])
}

class QueryModel{
    var delegate: MainQueryModelProtocol!
    let urlPath = "https://zeushahn.github.io/Test/ios/movies.json"
    
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
        var locations : [DBModelMain] = []
        do{
            let addresses = try decoder.decode([MainJson].self, from : data)
            for address in addresses{
                let query = DBModelMain(name: address.name, phone: address.phone)
                locations.append(query)
            }
            
        } catch{
            print("Failed : \(error.localizedDescription)")
        }
        self.delegate.itemDownloaded(items: locations)
    }
    
}/// MainQueryModel


