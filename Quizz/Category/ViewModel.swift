//
//  ViewModel.swift
//  Quizz
//
//  Created by Balaji Pandian on 31/07/20.
//  Copyright © 2020 Balaji Pandian. All rights reserved.
//

import Foundation
import UIKit

class CategoryViewModel  {
    
    
   weak var vc : CategaryListViewController!
    
    
    var listQuizzQuestions = [Result]()
    var Category = [String]()
    

    /// Request API
    func requestAPI(completionHandler: @escaping ([Result]) -> Void) {
        
        let url = URL(string: "http://www.json-generator.com/api/json/get/cggtPLmLfS?indent=2")!
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print("Error with fetching : \(error)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("Error with the response, unexpected status code: \(response!)")
                    return
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                do{
                    let decodeValue = try decoder.decode(Quizz.self, from: data)
                    
                    
                    print(decodeValue)
                    self.listQuizzQuestions = decodeValue.results
                    completionHandler(decodeValue.results)
                    var tempCategary = [String]()
                    for i in decodeValue.results{
                        tempCategary.append(i.category.rawValue)
                    }
                    self.Category = Array(Set(tempCategary))
                    print(tempCategary,self.Category)
                    DispatchQueue.main.async {
                        self.vc.tableView.reloadData()
                    }
                    
                } catch (let err) {
                    print("Error:\(err)")
                    
                }
            }
        })
        task.resume()
    }
    
}
