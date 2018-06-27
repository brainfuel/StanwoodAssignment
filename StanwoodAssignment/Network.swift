//
//  Network.swift
//  StanwoodAssignment
//
//  Created by Ben Milford on 26/06/2018.
//  Copyright © 2018 Ben Milford. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

/**
Handles requests using Alamofire for JSON and Images
*/


// MARK: - Retrieve Data

private let endPoint = "https://api.github.com/search/repositories"

class Network{

}

//TODO move these structs to the model

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
        //TODO parameters hard coded,make more generic , move out of block
        
        let parameters: Parameters = ["q": "created:>\(dateString)", "sort" : "stars", "order" : "desc", "page" : String(pageNumber)]
        
        Alamofire.request(endPoint, parameters: parameters).responseData { response in
            
          ActivityIndicatorManager.endActivity()
            //TODO improve validation
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
            print("Error", err)
        }
        
        return gitData
    }
}


// MARK: - Retrieve Image
//Obtain image from network, cache and resize image

enum ImageSize : String {
    case thumbnail = "THUMB"
    case large = "LARGE"
    case fullSize = "FULL"
}

extension Network {
    //TODO AlamofireImage only supports in memory chache. Swwap for SDWebImage
    static let imageCache = AutoPurgingImageCache(memoryCapacity: 100_000_000, preferredMemoryUsageAfterPurge: 60_000_000)
    
    static  public func imageFromURLString (_ imageURLStr: String, imageSize :ImageSize, completionBlock: @escaping ( (UIImage) -> Void) ) {
        ActivityIndicatorManager.startActivity()
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let imageID = identifierFromURLString(imageURLStr, imageSize: imageSize)
            
            if let cachedImage = imageCache.image(withIdentifier: imageID){
                //Cached image found, no need to call request
                DispatchQueue.main.async {
                    completionBlock(cachedImage)
                }
            }
            
            Alamofire.request(imageURLStr).responseImage { response in
                ActivityIndicatorManager.endActivity()
                
                switch response.result {
                case .success:
                    if let image = response.result.value {
                        
                        let resizedImage = self.resizeImage(image, imageSize: imageSize)
                        
                        self.cacheImage(resizedImage, imageID: imageID)
                        
                        completionBlock(resizedImage)
                    }
                    
                    
                case .failure(let error):
                    print(error)
                    
                }
            }
        }
    }
    
    static private func cacheImage(_ image : Image, imageID : String){
        
        imageCache.add(image, withIdentifier: imageID)
    }
    
    static private func resizeImage(_ image : Image, imageSize :ImageSize) -> Image{
        
        //TODO Scrap ImageSize alltogether and pass width / height into block
        var size = CGSize(width: 60, height: 60) // add a thumnail size initializer
        switch imageSize {
        case .fullSize:
            return image
        case .large:
            size = CGSize(width: 154, height: 154)
        case .thumbnail:
            size = CGSize(width: 60, height: 60)
            
        }
        // Scale image to fill specified size while maintaining aspect ratio
        //TODO currently hard coded aspect. Should be passed into block
        let aspectScaledToFillImage = image.af_imageAspectScaled(toFill: size)
        
        return aspectScaledToFillImage
    }
    
    static private func identifierFromURLString(_ imageURLStr: String, imageSize :ImageSize)-> String{
        //Use the hash value as the identifier, along with appended ImageSize
        return String(URL(fileURLWithPath: imageURLStr).hashValue) + imageSize.rawValue
    }
}
