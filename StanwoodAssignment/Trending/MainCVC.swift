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
        mainViewModel.dataForTimePeriod(timePeriod: TimePeriod.month)
        /*
         let segment: UISegmentedControl = UISegmentedControl(items: ["First", "Second"])
         segment.sizeToFit()
         segment.tintColor = UIColor(red:0.99, green:0.00, blue:0.25, alpha:1.00)
         segment.selectedSegmentIndex = 0;*/
        //  segment.setTitleTextAttributes([NSAttributedString(string: "test", attributes: [NSAttributedStringKey.font : UIFont(name: "ProximaNova-Light", size: 15)])!],
        // for: UIControlState.Normal)
        
        //self.navigationItem.titleView = segment
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        print(mainViewModel.arrayForTimePeriod(TimePeriod.month).count)
        return mainViewModel.arrayForTimePeriod(TimePeriod.month).count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)  as! MainCVCell
        
        let repositoryArray = mainViewModel.arrayForTimePeriod(TimePeriod.month)
        let repositoryStruct =  repositoryArray[indexPath.row]
        
        
        if(indexPath.row == repositoryArray.count - 1){
            mainViewModel.dataForTimePeriod(timePeriod: TimePeriod.month)
        }
        
        cell.roundedLine()
        cell.backgroundColor = UIColor.veryLightGrey
        cell.avatarImage.roundedLine()
        cell.avatarImage.image = UIImage(named: "avatar")
        
        /*
        if let avatarURL = repositoryStruct.owner?.avatarURL {
            
            Network.imageFromURLString(avatarURL, imageSize: ImageSize.thumbnail) { (image) in
                cell.avatarImage.image = image
                //TODO add a transition here
            }
        }*/
        
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
        
        let repositoryStruct = mainViewModel.arrayForTimePeriod(TimePeriod.month)[indexPath.row]
        
        
        
        if(segue.identifier == "MainDetailsTVC"){
            let mainDetailsTVC = segue.destination as! MainDetailsTVC
            
            //mainDetailsTVC.repository = repositoryStruct
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
}

