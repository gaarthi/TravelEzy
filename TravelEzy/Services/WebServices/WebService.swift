//
//  WebService.swift
//  TravelEzy
//
//  Created by Aarthi on 30/03/22.
//

import Foundation
import Firebase

class WebService {
    
    static let sharedInstance = WebService()
    typealias completionHandler = (([String:Any]) -> ())
    typealias result = (([String:Any]) -> ())
    
    func performRequest(url: String, rootData: @escaping result) {
        guard let url = URL(string: url) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
            if let allData = jsonData {
                rootData(allData)
            }
            
        }.resume()
    }
    
    func fetchFromFirebase(parentName:String, cityName:String, childData: @escaping completionHandler) {
        
        var ref = DatabaseReference()
        if cityName.isEmpty{
            ref = Database.database().reference(withPath: parentName)
        } else {
            ref = Database.database().reference(withPath: parentName).child(cityName)
        }
        
        ref.observeSingleEvent(of: .value) { snap in
            guard let value = snap.value as? [String:Any] else
            { return }
            childData(value)
        }
    }
}
