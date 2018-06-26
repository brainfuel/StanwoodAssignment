//
//  Network.swift
//  StanwoodAssignment
//
//  Created by Ben Milford on 26/06/2018.
//  Copyright © 2018 Ben Milford. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - Retrieve Data

private let endPoint = "https://api.github.com/search/repositories"

class Network{

}


struct Items: Codable, Equatable{
    
    let items: [Repository]?
    
    static func == (lhs: Items, rhs: Items) -> Bool {
        return lhs == rhs
    }
}

struct Repository: Codable, Equatable  {
    
    let repoName :  String?
    let description :  String?
    let language :  String?
    let forks :  Int?
    let stars :  Int?
    let id :  Int?
    let creationDate :  String?
    let repositoryURL :  String?
    var owner : Owner?
    
    private enum CodingKeys: String, CodingKey {
        case repoName =  "name"
        case description
        case language
        case forks
        case stars = "stargazers_count"
        case id
        case creationDate =  "created_at"
        case repositoryURL = "html_url"
        case owner
    }
    
    static func == (lhs: Repository, rhs: Repository) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Owner: Codable  {
    let avatarURL :  String?
    let username :  String?
    
    private enum CodingKeys: String, CodingKey {
        
        case avatarURL = "avatar_url"
        case username = "login"
        
    }
    
}

extension Network{
    
    static public func reposFromDateString (_ dateString: String, pageNumber: Int, completionBlock: @escaping ( (Items?) -> Void) ) {
       ActivityIndicatorManager.startActivity()
        //TODO parameters and requestURL hard coded,make more generic , move out of block
        
        let parameters: Parameters = ["q": "created:>\(dateString)", "sort" : "stars", "order" : "desc", "page" : String(pageNumber)]
        
        Alamofire.request(endPoint, parameters: parameters).responseData { response in
            
          ActivityIndicatorManager.endActivity()
            
            switch response.result {
            case .success:
                if let result = response.result.value {
                    completionBlock(self.parseResults(result))
                }
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    static private func parseResults(_ results : Data) -> Items?{
        var gitData : Items?
        do {
            let decoder = JSONDecoder()
            gitData = try decoder.decode(Items.self, from: results)
            
        } catch let err {
            print("Err", err)
        }
        
        return gitData
    }
}

