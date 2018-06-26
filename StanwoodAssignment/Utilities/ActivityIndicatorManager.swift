//
//  ActivityIndicatorManager.swift
//  StanwoodAssignment
//
//  Created by Ben Milford on 26/06/2018.
//  Copyright © 2018 Ben Milford. All rights reserved.
//

import UIKit
import Foundation

class ActivityIndicatorManager{
    
    static private var activityCount = 0
    
    static public func startActivity(){
        activityCount += 1
        if activityCount == 0{
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
        }else{
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
    
    static public func endActivity(){
        activityCount -= 1
        
        if activityCount == 0{
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
        }else{
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
}
