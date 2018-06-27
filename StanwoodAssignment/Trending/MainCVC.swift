//
//  MainCVC.swift
//  StanwoodAssignment
//
//  Created by Ben Milford on 26/06/2018.
//  Copyright © 2018 Ben Milford. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MainCVCell"

class MainCVC: UICollectionViewController  {
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    fileprivate var itemsPerRow = 1
    fileprivate let heightPerItem = 143
    fileprivate let minimumWidthPerItem = 300.00
    
    let mainViewModel = MainViewModel()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            itemsPerRow = 2
        }
        
        mainViewModel.delegate = self
        mainViewModel.dataForTimePeriod(timePeriod: Model.currentlySelectedTimePeriod)
        
        /*
         let segment: UISegmentedControl = UISegmentedControl(items: ["First", "Second"])
         segment.sizeToFit()
         segment.tintColor = UIColor(red:0.99, green:0.00, blue:0.25, alpha:1.00)
         segment.selectedSegmentIndex = 0;*/
        //  segment.setTitleTextAttributes([NSAttributedString(string: "test", attributes: [NSAttributedStringKey.font : UIFont(name: "ProximaNova-Light", size: 15)])!],
        // for: UIControlState.Normal)
        
        //self.navigationItem.titleView = segment
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.timePeriodChanged(notification:)), name: Notification.Name("timePeriodChanged"), object: nil)
       
    
    }
 
    
    @objc func timePeriodChanged(notification: Notification){
        collectionView?.reloadData()
        
        //Scroll to top. Offset hack to stop scrolling past required point
        let topOffest = CGPoint(x: 0, y: -44)
        self.collectionView?.setContentOffset(topOffest, animated: false)
        
        //If this is the first time this tab has been called, start download
        if mainViewModel.arrayForTimePeriod(Model.currentlySelectedTimePeriod).count == 0{
        mainViewModel.dataForTimePeriod(timePeriod: Model.currentlySelectedTimePeriod)
        }
        
     
            navigationController?.popToRootViewController(animated: true)
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
         NotificationCenter.default.post(name: Notification.Name("trendingScreenAppeared"), object: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
       print(mainViewModel.arrayForTimePeriod(Model.currentlySelectedTimePeriod).count)
        
        return mainViewModel.arrayForTimePeriod(Model.currentlySelectedTimePeriod).count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)  as! MainCVCell
        
        let repositoryArray = mainViewModel.arrayForTimePeriod(Model.currentlySelectedTimePeriod)
        let repositoryStruct =  repositoryArray[indexPath.row]
        
        
        if(indexPath.row == repositoryArray.count - 1){
            mainViewModel.dataForTimePeriod(timePeriod: Model.currentlySelectedTimePeriod)
        }
        
        cell.roundedLine()
        cell.backgroundColor = UIColor.veryLightGrey
        cell.avatarImage.roundedLine()
        cell.avatarImage.image = UIImage(named: "avatar")
       cell.delegate = self
        if let id = repositoryStruct.id{
            cell.starButton.isSelected = mainViewModel.isFavoritedFromID(id)
        }
       
        if let avatarURL = repositoryStruct.owner?.avatarURL {
            
            Network.imageFromURLString(avatarURL, imageSize: ImageSize.thumbnail) { (image) in
                cell.avatarImage.image = image
                //TODO add a transition here
            }
        }
        
        cell.repositoryNameLabel.text = repositoryStruct.repoName
        cell.usernameLabel.text = repositoryStruct.owner?.username
        cell.startsLabel.text = "☆ \(String(repositoryStruct.stars ?? 0))"
        cell.descriptionLabel.text = repositoryStruct.description
        // Configure the cell
        
        return cell
    }
    
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let point = (sender as? UICollectionViewCell)?.center else{return}
        guard let indexPath =   self.collectionView?.indexPathForItem(at: point) else {return}
        
        let repositoryStruct = mainViewModel.arrayForTimePeriod(Model.currentlySelectedTimePeriod)[indexPath.row]
        
         NotificationCenter.default.post(name: Notification.Name("leavingTrendingScreen"), object: self)
        
        if(segue.identifier == "MainDetailsTVC"){
            let mainDetailsTVC = segue.destination as! MainDetailsTVC
            
            mainDetailsTVC.repository = repositoryStruct
        }
        
    }
}

// MARK: - Layout
extension MainCVC : UICollectionViewDelegateFlowLayout {
    
    //Resize collection view on rotate
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
    }
    
    //Calculate the item size based on view width
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        itemsPerRow =  Int(CGFloat(view.frame.width) / CGFloat(minimumWidthPerItem))
        //Make sure there is at least one item per row no matter what the available size
        if itemsPerRow < 1 {   itemsPerRow = 1  }
        
        let paddingSpace = CGFloat(sectionInsets.left) * CGFloat(itemsPerRow + 1)
        let availableWidth = CGFloat(view.frame.width) - paddingSpace
        
        
        let widthPerItem = CGFloat(availableWidth) / CGFloat(itemsPerRow)
        
        return CGSize(width: widthPerItem, height: CGFloat(heightPerItem) )
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

// MARK: - Paging
extension MainCVC : MainViewModelProtocol {
    func didRecievePageData(_ pageData: [Repository],newIndexPaths : [IndexPath], fullData: [Repository]) {
        
        collectionView?.performBatchUpdates({ () -> Void in
            self.collectionView?.insertItems(at: newIndexPaths)
            
            
        }, completion: nil)
        
    }
    
    func removeItemAtIndexPath(_ indexPath : IndexPath ){
        collectionView?.performBatchUpdates({ () -> Void in
            self.collectionView?.deleteItems(at: [indexPath])
            
            
        }, completion: nil)
        
    }
}

extension MainCVC  : MainCVCellDelegate  {
    func didPressStarButton(_ sender: UIButton) {
        if let indexPath =  collectionView?.indexPathForItem(at: (collectionView?.convert(sender.center, from: sender.superview))!){
            
            mainViewModel.starSelectedAtRow(indexPath.row)
     
            
        }
    }
    
}
