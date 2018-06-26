//
//  MainViewModel.swift
//  StanwoodAssignment
//
//  Created by Ben Milford on 26/06/2018.
//  Copyright © 2018 Ben Milford. All rights reserved.
//

import Foundation

//Have to add 'anyObject' else can't set as weak delegate reference
protocol MainViewModelProtocol : AnyObject {
    func didRecievePageData(_ pageData : [Repository], newIndexPaths : [IndexPath], fullData : [Repository])
}

enum TimePeriod {
    case month
    case week
    case day
}

class MainViewModel  {
    var timePeriod = TimePeriod.month
    
    var monthArray = PagedArray<Repository>()
    var weekArray = PagedArray<Repository>()
    var dayArray = PagedArray<Repository>()
    
    weak var delegate: MainViewModelProtocol?
    
    private func dateStringForTimePeriod(_ timePeriod: TimePeriod) -> String?{
        
        let now = Date()
        
        switch timePeriod {
        case .month:
            return now.pastMonth()?.toStringISO()
        case .week:
            return now.pastWeek()?.toStringISO()
        case .day:
            return now.pastDay()?.toStringISO()
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
        }
    }
    
    public  func dataForTimePeriod(timePeriod: TimePeriod){
        
        guard let dateString = dateStringForTimePeriod(timePeriod) else {return}
        var dataArray = pagedArrayForTimePeriod(timePeriod)
        
        let pageToGetInt = dataArray.pageCount + 1
        //If we have already obtained all the data for this month no need to fire request
        if dataArray.isComplete{
            let fullData = Array(dataArray)
            self.delegate?.didRecievePageData([Repository](),newIndexPaths : [IndexPath](),  fullData : fullData )
        }
        
        Network.reposFromDateString(dateString, pageNumber: pageToGetInt, completionBlock: { (completion) in

            if let items = completion?.items{
                //make the new range of items
                let range = NSRange(location: dataArray.count, length: items.count - 1)
                let newIndexPaths = self.indexPathsForRange(range: range)
                
                self.addPage(items, for: timePeriod)
                dataArray.addPage(items)
                let fullData = Array(dataArray)
                self.delegate?.didRecievePageData(items, newIndexPaths: newIndexPaths, fullData : fullData )
                print(dataArray.count)
                
            }
            
            
        })
        
    }

    func indexPathsForRange(range: NSRange)->[IndexPath]{
        var indexPaths = [IndexPath]()
        
        for i in range.location...range.location + range.length{
            indexPaths.append(IndexPath(row: i, section: 0))
        }
        return indexPaths
    }

}
