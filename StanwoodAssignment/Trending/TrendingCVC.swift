//
//  MainCVC.swift
//  StanwoodAssignment
//
//  Created by Ben Milford on 26/06/2018.
//  Copyright © 2018 Ben Milford. All rights reserved.
//

import UIKit

private let reuseIdentifier = "TrendingCVCell"

class TrendingCVC: UICollectionViewController  {
    
    //Set properties for layout
    fileprivate let sectionInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    fileprivate var itemsPerRow = 1
    fileprivate let heightPerItem = 143
    fileprivate let minimumWidthPerItem = 300.00
    
    let mainViewModel = TrendingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            itemsPerRow = 2
        }
        
        mainViewModel.delegate = self
        mainViewModel.dataForTimePeriod(timePeriod: Model.currentlySelectedTimePeriod)
        
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
        //TODO unsafe place to put this notification as could be accidently called by a popup or similar. Remove notification and exchange for alternative event system
        NotificationCenter.default.post(name: Notification.Name("trendingScreenAppeared"), object: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return mainViewModel.arrayForTimePeriod(Model.currentlySelectedTimePeriod).count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)  as! TrendingCVCell
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let point = (sender as? UICollectionViewCell)?.center else{return}
        guard let indexPath =   self.collectionView?.indexPathForItem(at: point) else {return}
        
        let repositoryStruct = mainViewModel.arrayForTimePeriod(Model.currentlySelectedTimePeriod)[indexPath.row]
        
        NotificationCenter.default.post(name: Notification.Name("leavingTrendingScreen"), object: self)
        
        if(segue.identifier == "MainDetailsTVC"){
            let mainDetailsTVC = segue.destination as! DetailsTVC
            
            mainDetailsTVC.repository = repositoryStruct
        }
        
    }
}

// MARK: - Layout
extension TrendingCVC : UICollectionViewDelegateFlowLayout {
    
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
extension TrendingCVC : TrendingViewModelProtocol {
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

extension TrendingCVC  : TrendingCVCellDelegate  {
    func didPressStarButton(_ sender: UIButton) {
        if let indexPath =  collectionView?.indexPathForItem(at: (collectionView?.convert(sender.center, from: sender.superview))!){
            
            mainViewModel.starSelectedAtRow(indexPath.row)
        }
    }
}
