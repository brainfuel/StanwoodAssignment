//
//  MainViewModel.swift
//  StanwoodAssignment
//
//  Created by Ben Milford on 26/06/2018.
//  Copyright © 2018 Ben Milford. All rights reserved.
//

import Foundation

//Have to add 'anyObject' else can't set as weak delegate reference
protocol TrendingViewModelProtocol : AnyObject {
    func didRecievePageData(_ pageData : [Repository], newIndexPaths : [IndexPath], fullData : [Repository])
    func removeItemAtIndexPath(_ indexPath : IndexPath )
}

enum TimePeriod {
    case month
    case week
    case day
    case favorite
}

class TrendingViewModel{
    
    var monthArray = PagedArray<Repository>()
    var weekArray = PagedArray<Repository>()
    var dayArray = PagedArray<Repository>()
    var favoritesArray = PagedArray<Repository>()
    
    weak var delegate: TrendingViewModelProtocol?
    
    init() {
        loadFavorites()
    }
    
    private func dateStringForTimePeriod(_ timePeriod: TimePeriod) -> String?{
        
        let now = Date()
        
        switch timePeriod {
        case .month:
            return now.pastMonth()?.toStringISO()
        case .week:
            return now.pastWeek()?.toStringISO()
        case .day:
            return now.pastDay()?.toStringISO()
        case .favorite:
            return now.pastMonth()?.toStringISO() //Currently unused
        }
    }
    
    private func pagedArrayForTimePeriod(_ timePeriod: TimePeriod) -> PagedArray<Repository>{
        switch timePeriod {
        case .month:
            return monthArray
        case .week:
            return weekArray
        case .day:
            return dayArray
        case .favorite:
            return favoritesArray
        }
    }
    
    public func arrayForTimePeriod(_ timePeriod: TimePeriod) -> [Repository]{
        switch timePeriod {
        case .month:
            return Array(monthArray)
        case .week:
            return Array(weekArray)
        case .day:
            return Array(dayArray)
        case .favorite:
            return Array(favoritesArray)
        }
    }
    
    public func addPage(_ page: [Repository], for timePeriod: TimePeriod){
        switch timePeriod {
        case .month:
            monthArray.addPage(page)
        case .week:
            weekArray.addPage(page)
        case .day:
            dayArray.addPage(page)
        case .favorite:
            favoritesArray.addPage(page)
        }
    }
    
    public  func dataForTimePeriod(timePeriod: TimePeriod){
        
        var dataArray = pagedArrayForTimePeriod(timePeriod)
        
        if timePeriod == TimePeriod.favorite{
            // Favorites stored locally, no need to request
            let fullData = Array(dataArray)
            self.delegate?.didRecievePageData([Repository](), newIndexPaths: [IndexPath](), fullData : fullData )
            return
        }
        
        guard let dateString = dateStringForTimePeriod(timePeriod) else {return}
        
        let pageToGetInt = dataArray.pageCount + 1
        //If we have already obtained all the data for this month no need to fire request
        if dataArray.isComplete{
            let fullData = Array(dataArray)
            self.delegate?.didRecievePageData([Repository](),newIndexPaths : [IndexPath](),  fullData : fullData )
        }
        
        Network.reposFromDateString(dateString, pageNumber: pageToGetInt, completionBlock: { (completion) in
            //Get data array again incase it's changed
            dataArray = self.pagedArrayForTimePeriod(timePeriod)
            if let items = completion?.items{
                //make the new range of items
                let range = NSRange(location: dataArray.count, length: items.count - 1)
                let newIndexPaths = self.indexPathsForRange(range: range)
                
                self.addPage(items, for: timePeriod)
                
                let fullData = Array(dataArray)
                
                if Model.currentlySelectedTimePeriod == timePeriod{
                    self.delegate?.didRecievePageData(items, newIndexPaths: newIndexPaths, fullData : fullData )
                }
            }
        })
    }
    
    private func indexPathsForRange(range: NSRange)->[IndexPath]{
        var indexPaths = [IndexPath]()
        
        for i in range.location...range.location + range.length{
            indexPaths.append(IndexPath(row: i, section: 0))
        }
        return indexPaths
    }
    
    private func repositoryForTimePeriod(_ timePeriod: TimePeriod, row : Int)-> Repository{
        let array = arrayForTimePeriod(timePeriod)
        return array[row]
    }
    
    private func repositoryForTimePeriod(_ timePeriod: TimePeriod, id : Int)-> Repository?{
        let array = arrayForTimePeriod(timePeriod)
        let foundRepository = array.filter{$0.id == id}.first
        return foundRepository
    }
    
    public func isFavoritedFromID(_  id : Int)-> Bool{
        if   repositoryForTimePeriod(TimePeriod.favorite, id: id) == nil {
            return false
        }
        return true
    }
    
    private func deleteRepositoryForTimePeriod(_ timePeriod: TimePeriod, row : Int){
        
        switch timePeriod {
        case .month:
            monthArray.removeRow(row: row)
        case .week:
            weekArray.removeRow(row: row)
        case .day:
            dayArray.removeRow(row: row)
        case .favorite:
            favoritesArray.removeRow(row: row)
        }
    }
    
    private func loadFavorites(){
        
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: "created", ascending: false)
        let repositoriesMO =  RepositoryMO.findAllSortedBy([descriptor]) as [RepositoryMO]
        
        var repositories = [Repository]()
        for repositoryMO in repositoriesMO{
            
            repositories.append(RepositoryMapper.repositoryFrom(managedObject: repositoryMO))
            
        }
        favoritesArray.removeAll()
        addPage(repositories, for: TimePeriod.favorite)
    }
}

extension TrendingViewModel{
    
    func  starSelectedAtRow(_ row : Int){
        //TODO Remove hard coded model from this entire class
        let repository = repositoryForTimePeriod(Model.currentlySelectedTimePeriod, row: row)
        guard let id = repository.id else { return}
        
        let foundRepository = repositoryForTimePeriod(TimePeriod.favorite, id: id)
        
        if(foundRepository == nil){
            //If we never found a repo in favorites with that id, then save
            let repositoryMO =  RepositoryMapper.managedObjectFrom(repository: repository)
            repositoryMO.selected = true
            CoreRecord.shared.save()
            loadFavorites()
        }else {
            //Remove from paged array
            if TimePeriod.favorite == Model.currentlySelectedTimePeriod{
                deleteRepositoryForTimePeriod(Model.currentlySelectedTimePeriod, row: row)
                //Remove from core data also
                let predicate = NSPredicate(format: "githubID == %d", id)
                let repositoryMO = RepositoryMO.findAllWithPredicate(predicate).first
                repositoryMO?.delete()
                CoreRecord.shared.save()
                
                //Inform delegate of deletion
                let indexPath = IndexPath(row: row, section: 0)
                self.delegate?.removeItemAtIndexPath(indexPath)
            }
        }
    }
}
