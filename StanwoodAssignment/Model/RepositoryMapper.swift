//
//  RepositoryMapper.swift
//  StanwoodAssignment
//
//  Created by Ben Milford on 26/06/2018.
//  Copyright © 2018 Ben Milford. All rights reserved.
//

import Foundation

/**
 Converts Repository struct to and from and Core Data compatible Repository Managed Object
 */

class RepositoryMapper {
    
    static func repositoryFrom(managedObject : RepositoryMO) -> Repository{
        
        let owner = Owner(avatarURL: managedObject.avatarURL, username: managedObject.username)
        
        let repository =   Repository(
            repoName: managedObject.repoName,
            description: managedObject.desc,
            language: managedObject.language,
            forks: Int(managedObject.forks),
            stars: Int(managedObject.stars),
            id: Int(managedObject.githubID),
            creationDate: managedObject.creationDate,
            repositoryURL: managedObject.repositoryURL,
            owner: owner)
        return repository
    }
    
    static func managedObjectFrom(repository : Repository) -> RepositoryMO{
        
        let repositoryMO: RepositoryMO  = RepositoryMO.create()
        repositoryMO.repoName = repository.repoName
        repositoryMO.desc = repository.description
        repositoryMO.language = repository.language
        if let forks = repository.forks{
            repositoryMO.forks = Int32(forks)
        }
        if let stars = repository.stars{
            repositoryMO.stars = Int32(stars)
        }
        if let githubID = repository.id{
            repositoryMO.githubID = Int32(githubID)
        }
        repositoryMO.creationDate = repository.creationDate
        repositoryMO.repositoryURL = repository.repositoryURL
        
        //Owner data
        repositoryMO.avatarURL = repository.owner?.avatarURL
        repositoryMO.username = repository.owner?.username
        
        return repositoryMO
    }
}


