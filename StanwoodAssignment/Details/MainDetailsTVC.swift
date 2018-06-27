//
//  MainDetailsTVC.swift
//  StanwoodAssignment
//
//  Created by Ben Milford on 26/06/2018.
//  Copyright © 2018 Ben Milford. All rights reserved.
//

import UIKit



class MainDetailsTVC: UITableViewController {

    var repository: Repository?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Details"
        self.view.backgroundColor = UIColor.veryLightGrey
        self.tableView.estimatedRowHeight = 200
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            let titleCell = tableView.dequeueReusableCell(withIdentifier: "MainDetailsTitleCell", for: indexPath) as! MainDetailsTitleCell
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
            let descriptionCell = tableView.dequeueReusableCell(withIdentifier: "MainDetailsDescriptionCell", for: indexPath) as! MainDetailsDescriptionCell
            descriptionCell.backgroundColor = UIColor.veryLightGrey
           descriptionCell.descriptionLabel.text = repository.description
            return descriptionCell
            
        case 2:
            let descriptionCell = tableView.dequeueReusableCell(withIdentifier: "MainDetailsURLCell", for: indexPath) as! MainDetailsURLCell
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
        
        let standarCell = tableView.dequeueReusableCell(withIdentifier: "MainDetailsCell", for: indexPath) as! MainDetailsCell
        standarCell.backgroundColor = UIColor.veryLightGrey
        standarCell.titleLabel.text = title
        standarCell.detailLabel.text = detail
        
        return standarCell

    }
    
    @objc func copyButtonPressed(){
        
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = repository?.repositoryURL
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
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
