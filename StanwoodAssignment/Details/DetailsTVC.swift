//
//  MainDetailsTVC.swift
//  StanwoodAssignment
//
//  Created by Ben Milford on 26/06/2018.
//  Copyright © 2018 Ben Milford. All rights reserved.
//


/**
 Details TableViewController
 Data is passed by TrendingCVC in prepareForSegue
 */

import UIKit

class DetailsTVC: UITableViewController {
    
    var repository: Repository?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Details"
        self.view.backgroundColor = UIColor.veryLightGrey
        self.tableView.estimatedRowHeight = 200
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let repository = repository else {return ""}
        
        return repository.repoName
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let repository = repository else {return UITableViewCell()}
        
        var title : String? = ""
        var detail : String? = ""
        
        switch indexPath.row {
        case 0:
            let titleCell = tableView.dequeueReusableCell(withIdentifier: "DetailsTitleCell", for: indexPath) as! DetailsTitleCell
            titleCell.backgroundColor = UIColor.veryLightGrey
            titleCell.avatarImage.roundedLineMedium()
            
            titleCell.detailsLabel1.text = repository.owner?.username
            titleCell.detailsLabel2.text = "☆ \(String(repository.stars ?? 0))"
            titleCell.detailsLabel3.text = "⑂ \(String(repository.forks ?? 0))"
            
            if let avatarURL = repository.owner?.avatarURL {
                
                Network.imageFromURLString(avatarURL, imageSize: ImageSize.large) { (image) in
                    titleCell.avatarImage.image = image
                    //TODO add a transition here
                }
            }
            
            return titleCell
            
        case 1:
            let descriptionCell = tableView.dequeueReusableCell(withIdentifier: "DetailsDescriptionCell", for: indexPath) as! DetailsDescriptionCell
            descriptionCell.backgroundColor = UIColor.veryLightGrey
            descriptionCell.descriptionLabel.text = repository.description
            return descriptionCell
            
        case 2:
            let descriptionCell = tableView.dequeueReusableCell(withIdentifier: "DetailsURLCell", for: indexPath) as! DetailsURLCell
            descriptionCell.backgroundColor = UIColor.veryLightGrey
            descriptionCell.copyButton.roundedLine()
            descriptionCell.viewButton.roundedLine()
            descriptionCell.titleLabel.text = "GitHub URL:"
            descriptionCell.copyButton.addTarget(self, action:#selector(self.copyButtonPressed), for: .touchUpInside)
            
            return descriptionCell
            
        case 3:
            title = "Language:"
            detail = repository.language
        case 4:
            title = "Creation Date:"
            detail = repository.creationDate
            
        default:
            title = ""
            detail = ""
        }
        
        let standarCell = tableView.dequeueReusableCell(withIdentifier: "DetailsCell", for: indexPath) as! DetailsCell
        standarCell.backgroundColor = UIColor.veryLightGrey
        standarCell.titleLabel.text = title
        standarCell.detailLabel.text = detail
        
        return standarCell
    }
    
    @objc func copyButtonPressed(){
        
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = repository?.repositoryURL
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "WebVC"){
            let   webVC = segue.destination as! WebVC
            
            if let url = repository?.repositoryURL{
                webVC.url = url
                webVC.title = "Repo Viewer"
            }
        }
    }
}
