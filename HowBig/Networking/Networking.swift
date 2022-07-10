//
//  Networking.swift
//  HowBig
//
//  Created by Anton on 07.07.2022.
//

import Foundation

class Networking {
    func getDogs(handler: @escaping ([Dog]) -> ()) {
        let url = URL(string: "https://api.thedogapi.com/v1/breeds")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let dogs = try? JSONDecoder().decode([Dog].self, from: data) {
                    handler(dogs)
                } else {
                    print("Invalid Response")
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }
        task.resume()
    }
}
