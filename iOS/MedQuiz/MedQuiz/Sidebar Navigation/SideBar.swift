//
//  NavTableViewController.swift
//  MedQuiz
//
//  Created by Maddy Transue on 11/7/17.
//  Copyright © 2017 Omar Sherief. All rights reserved.
//

import UIKit
import Firebase

class SideBar: UITableViewController {
    
    var QuizStoryboard:UIStoryboard? = nil
    var LeaderboardStoryboard:UIStoryboard? = nil
    var ProfileStoryboard:UIStoryboard? = nil
    var AboutStoryboard:UIStoryboard? = nil
    
    let blueProfCellColor = UIColor(red: (111/255.0), green: (229/255.0), blue: (203/255.0), alpha: 1.0)
    let mainCellBlue = UIColor(red: (67/255.0), green: (158/255.0), blue: (196/255.0), alpha: 1.0)
    let mainCellSelectedBlue = UIColor(red: (45/255.0), green: (113/255.0), blue: (142/255.0), alpha: 1.0)
    let whiteColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1.0)
    
    var checkTotalPointsUpdateRef:DatabaseReference!
    var checkTotalPointsUpdateHandle:DatabaseHandle!
    var checkTotalPointsUpdateSet = false
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //Hides top "title" bar
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        //Registering the side bar nib to use in tableview
        let sideNavNib = UINib(nibName: "SideBarCell", bundle: nil)
        self.tableView.register(sideNavNib, forCellReuseIdentifier: "customSideCell")
        
        let profSideNib = UINib(nibName: "ProfileSideBarCell", bundle: nil)
        self.tableView.register(profSideNib, forCellReuseIdentifier: "profileCell")
        
        self.tableView.separatorStyle = .none
        
        //Reference to the Quiz's storyboard
        QuizStoryboard = UIStoryboard(name: "Quiz", bundle: nil)
        
        //Reference to the Leaderboard's storyboard
        LeaderboardStoryboard = UIStoryboard(name: "Leaderboard", bundle: nil)
        
        //Reference to the Profile's storyboard
        ProfileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        
        //Reference to the About's storyboard
        AboutStoryboard = UIStoryboard(name: "About", bundle: nil)
        
        //Set the initial vc to the quiz's
        splitViewController?.showDetailViewController(QuizStoryboard!.instantiateInitialViewController()!, sender: Any?.self)

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(false)
        removeListeners()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0 && indexPath.row == 0){
            return 130
        }
        else if(indexPath.row < 5){
            return 100
        }
        else{
            return -1
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tableView.backgroundColor = mainCellBlue

        if(indexPath.row == 0)
        {
            let aProfBarCell:ProfileSideBarCell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileSideBarCell
            
            //aProfBarCell.profileImage.center = aProfBarCell.center
            
            aProfBarCell.profileImage.image = globalProfileImage
            
            aProfBarCell.profileNameLabel.text = globalUsername
            
            aProfBarCell.profileNameLabel.textColor = whiteColor
            
            /*let currentName = aProfBarCell.profileNameLabel.text
            aProfBarCell.scoreLabel.text = getScore(name: currentName!)*/
            
            checkTotalPointsUpdateRef = Database.database().reference(withPath:"student/\(currentUserID)/score")
            checkTotalPointsUpdateHandle = checkTotalPointsUpdateRef.observe(.value, with: { snapshot in
                self.checkTotalPointsUpdateSet = true
                
                let scoreFormatter = NumberFormatter()
                scoreFormatter.numberStyle = NumberFormatter.Style.decimal
                
                aProfBarCell.scoreNumberLabel.text = scoreFormatter.string(from: NSNumber(value: snapshot.value as! Int))
            })
            
            aProfBarCell.scoreNumberLabel.textColor = whiteColor
            aProfBarCell.scoreNumberLabel.sizeToFit()
            
            aProfBarCell.isUserInteractionEnabled = false
            
            aProfBarCell.backgroundColor = blueProfCellColor
            aProfBarCell.layer.shadowOffset = CGSize(width: 0, height: 20)
            
            aProfBarCell.layer.shadowRadius = 5
            aProfBarCell.layer.shadowOpacity = 0.3
            
            return aProfBarCell
        }
        let aSideBarCell:SideBarCell = tableView.dequeueReusableCell(withIdentifier: "customSideCell", for: indexPath) as! SideBarCell
        aSideBarCell.backgroundColor = mainCellBlue
        
        aSideBarCell.layer.cornerRadius = 10
        
        if(indexPath.section == 0 && indexPath.row == 1){
            aSideBarCell.navigateToPage.text = "Quiz"
            aSideBarCell.navigateToPage.textColor = whiteColor
            aSideBarCell.backgroundColor = mainCellSelectedBlue
            return aSideBarCell
        }
        else if(indexPath.section == 0 && indexPath.row == 2){
            aSideBarCell.navigateToPage.text = "Leaderboard"
            aSideBarCell.navigateToPage.textColor = whiteColor
            return aSideBarCell
        }
        else if(indexPath.section == 0 && indexPath.row == 3){
            aSideBarCell.navigateToPage.text = "Profile"
            aSideBarCell.navigateToPage.textColor = whiteColor
            return aSideBarCell
        }
        else if(indexPath.section == 0 && indexPath.row == 4){
            aSideBarCell.navigateToPage.text = "About"
            aSideBarCell.navigateToPage.textColor = whiteColor
            return aSideBarCell
        }
        else{
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.tableView.deselectRow(at: indexPath, animated: true)
        
        for index in 1...5{
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
            cell?.contentView.backgroundColor = mainCellBlue
        }
        
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = mainCellSelectedBlue
        
        if(indexPath.section == 0 && indexPath.row == 1){
            splitViewController?.showDetailViewController(QuizStoryboard!.instantiateInitialViewController()!, sender: Any?.self)
        }
        else if(indexPath.section == 0 && indexPath.row == 2){
            splitViewController?.showDetailViewController(LeaderboardStoryboard!.instantiateInitialViewController()!, sender: Any?.self)
        }
        else if(indexPath.section == 0 && indexPath.row == 3){
            splitViewController?.showDetailViewController(ProfileStoryboard!.instantiateInitialViewController()!, sender: Any?.self)
        }
        else if(indexPath.section == 0 && indexPath.row == 4){
            splitViewController?.showDetailViewController(AboutStoryboard!.instantiateInitialViewController()!, sender: Any?.self)
        }
    }
    
    func getScore(name: String) -> String{
        //get score from db
        return "4,434,534"
    }

    func removeListeners(){
        if checkTotalPointsUpdateSet {
            checkTotalPointsUpdateRef.removeObserver(withHandle: checkTotalPointsUpdateHandle)
        }
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

}
