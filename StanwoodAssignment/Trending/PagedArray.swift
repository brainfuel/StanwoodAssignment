//
//  PagedArray.swift
//  StanwoodAssignment
//
//  Created by Ben Milford on 26/06/2018.
//  Copyright © 2018 Ben Milford. All rights reserved.
//

import Foundation

struct PagedArray<T>   {
    
    typealias ArrayType = [T]
    
    var array: [T] = [T]()
    var itemsCount = 0
    var pageCount = 0
    var isComplete = false
    
    /// Sets a page of contents and increments page count
    public mutating func addPage(_ pageData: [T]) {
        
        self.array.append(contentsOf: pageData)
        pageCount += 1
    }
    
    /// Remove
    public mutating func removeRow(row : Int) {
        self.array.remove(at: row)
    }
    
    public mutating func removeAll(){
        self.array.removeAll()
    }
}

extension PagedArray : Sequence, IteratorProtocol {
    mutating func next() -> T? {
        
        if itemsCount >= array.count{
            return nil
        }
        
        defer { itemsCount += 1 }
        return array[itemsCount]
    }
}

extension PagedArray: Collection {
    
    typealias Element = ArrayType.Element
    typealias Index = ArrayType.Index
    
    // The upper and lower bounds of the collection, used in iterations
    var startIndex: Index { return array.startIndex }
    var endIndex: Index { return array.endIndex }
    // Required subscript, based on a dictionary index
    
    subscript(index: Index) -> ArrayType.Element {
        get { return array[index] }
    }
    // Method that returns the next index when iterating
    func index(after i: PagedArray.ArrayType.Index) -> PagedArray.ArrayType.Index {
        return array.index(after: i)
    }
}
