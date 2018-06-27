//
//  ViewController.swift
//  StanwoodAssignment
//
//  Created by Ben Milford on 26/06/2018.
//  Copyright © 2018 Ben Milford. All rights reserved.
//

/**
Controls the state of TabBar. Notifies of changes
 */

import UIKit


class RootViewController:UIViewController, UITabBarDelegate{
    
    @IBOutlet weak var tabBar: UITabBar!
    private var selectedItem = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO we should be obtaining selected item from  Model.currentlySelectedTimePeriod NOT using selectedItem here. Remove selectedItem entirely
        //Set initial selected tab item
        tabBar.selectedItem = tabBar.items![selectedItem] as UITabBarItem;
        
        //TODO exchange these notifications for a central controller
        NotificationCenter.default.addObserver(self, selector: #selector(self.leavingTrendingScreen(notification:)), name: Notification.Name("leavingTrendingScreen"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.trendingScreenAppeared(notification:)), name: Notification.Name("trendingScreenAppeared"), object: nil)
    }
    
    @objc func leavingTrendingScreen(notification: Notification){
        tabBar.selectedItem = nil
        if let tag = tabBar.selectedItem?.tag{
            selectedItem = tag
        }
    }
    
    @objc func trendingScreenAppeared(notification: Notification){
        tabBar.selectedItem = tabBar.items![selectedItem] as UITabBarItem;
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        switch (item.tag)
        {
        case 0:
            Model.currentlySelectedTimePeriod = TimePeriod.month
        case 1:
            Model.currentlySelectedTimePeriod = TimePeriod.week
        case 2:
            Model.currentlySelectedTimePeriod = TimePeriod.day
        case 3:
            Model.currentlySelectedTimePeriod = TimePeriod.favorite
        default:
            Model.currentlySelectedTimePeriod = TimePeriod.month
        }
        
        selectedItem = item.tag
        
        NotificationCenter.default.post(name: Notification.Name("timePeriodChanged"), object: tabBar)
    }
}
