//
//  QueryModel.swift
//  testProject
//
//  Created by TJ on 2024/12/18.
//

import Foundation

protocol QueryModelProtocol{
    func itemDownloaded(items: [MyData])
}
class QueryModel{
    var delegate: QueryModelProtocol!
    let urlPath = "http://127.0.0.1:8000/user/user_select"
    
    func downloadItems()async{
        let url: URL = URL(string: urlPath)!
        
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            await parseJSON(data)
        }catch{
            print("Failed to download data: \(error.localizedDescription)")
        }
    }
    func parseJSON(_ data: Data)async{
        let decoder = JSONDecoder()
        var locations: [MyData] = []
        do{
            let images = try decoder.decode([DBJson].self, from: data)
            for image in images{
                let query = MyData(name: image.name, phone: image.phone, image: image.image)
                locations.append(query)
            }
        }catch{
            print("Failed : \(error.localizedDescription)")
        }
        self.delegate.itemDownloaded(items: locations)
    }
}
