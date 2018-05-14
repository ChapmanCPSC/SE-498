//
//  ExapandableTableViewController.swift
//  ExpandableTable
//
//  Created by Harnack, Paul (Student) on 2/15/18.
//  Copyright © 2018 Harnack, Paul (Student). All rights reserved.
//

import UIKit
import Firebase

/*
ExpandableTableViewController displays categories of quizzes that can be played in practice mode. Category nodes contain Subject nodes which contain
 QuizData nodes.
 */

class ExpandableTableViewController: UITableViewController {

    var cellDataNodes:[CellDataNode]!
    var currentlyShown:[CellDataNode]!
    var closingChildrenCount = 0
    // TODO figure out a way to make an array of cell types so that user doesn't have to add if statements to cast
    // var cellTypes:[CellType.Type] = [CategoryTableViewCell.self]

    /*
     Get quiz data from database (currently hardcoded examples).
     */
    
    func getCellData() {
        cellDataNodes = []
        currentlyShown = []

        Firebase.Database.database().reference()
            .child("tag")
            .observeSingleEvent(of: .value, with: { (snap:DataSnapshot) in
                for s in snap.children {
                    let tagModel = TagModel(snapshot: s as! DataSnapshot)

                    Tag(key: tagModel.key) { tag in
                        let currNode = CategoryDataNode(tag: tag, children: [], completionEvents: [])

                        tagModel.quizzesForTag.forEach { model in
                            Quiz(key: model.key) { quiz in
                                if(quiz.visible! && quiz.complete){
                                    currNode.children.append(QuizDataNode(quiz: quiz, children: [], completionEvents: []))
                                    if(currNode.children.count == 1){// only want to add the category if there's at least one quiz in it
                                        self.cellDataNodes.append(currNode)
                                        self.currentlyShown.append(currNode)
                                    }
                                    self.tableView.reloadData()
                                }
                            }
                        }
                    }

                }
            })

    }

    /*
     Get quiz data and setup table components.
     */
    
    override func viewDidLoad() {
        getCellData()
        super.viewDidLoad()
        let categoryNib = UINib(nibName: "CategoryTableViewCell", bundle: nil)
        self.tableView.register(categoryNib, forCellReuseIdentifier: CategoryTableViewCell.reuseIdentifier())

        let subjectNib = UINib(nibName: "SubjectTableViewCell", bundle: nil)
        self.tableView.register(subjectNib, forCellReuseIdentifier: SubjectTableViewCell.reuseIdentifier())

        let quizNib = UINib(nibName: "QuizTableViewCell", bundle: nil)
        self.tableView.register(quizNib, forCellReuseIdentifier: QuizTableViewCell.reuseIdentifier())
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    /*
     Return number of table sections (1).
     */
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    /*
     Return number of rows in current section.
     */
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*var count = 0

        cellData.forEach { node in
            if(node.hasChildren){
                count += node.getChildCount()
            }
            count += 1
         }*/

        var count = currentlyShown.count

        print("Row Count: \(count)")
        return count
    }

    /*
     Set and return table view cell at indexPath.
     */
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        // TODO figure out how this can be used to dequeue a cell?
        let node:CellDataNode = currentlyShown[row]

        if let castedNode = node as? CategoryDataNode {
            var cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.reuseIdentifier(), for: indexPath)
            if let castedCell = cell as? CategoryTableViewCell {
                castedCell.categoryDataNode = castedNode
                castedCell.updateViews()
            }
            cell.selectionStyle = .none
            return cell
        }
        else if let castedNode = node as? SubjectDataNode {
            var cell = tableView.dequeueReusableCell(withIdentifier: SubjectTableViewCell.reuseIdentifier(), for: indexPath)
            if let castedCell = cell as? SubjectTableViewCell {
                castedCell.subjectDataNode = castedNode
                castedCell.updateViews()
            }
            cell.selectionStyle = .none
            return cell
        }
        else if let castedNode = node as? QuizDataNode {
            var cell = tableView.dequeueReusableCell(withIdentifier: QuizTableViewCell.reuseIdentifier(), for: indexPath)
            if let castedCell = cell as? QuizTableViewCell {
                castedCell.quizDataNode = castedNode
                castedCell.delegate = self
                castedCell.updateViews()
            }
            cell.selectionStyle = .none
            return cell
        }


        //TODO add else ifs as I add cells

        assert(false, "Should not reach this point")
    }
    
    /*
     Expand or close selected Category and Subject nodes.
     */

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let cellDataNode:CellDataNode = currentlyShown[row]

        cellDataNode.completionEvents.forEach { event in event() }

        if(cellDataNode.hasChildren && !cellDataNode.isExpanded){
            cellDataNode.isExpanded = true
            // TODO figure out if begin/endUpdates is needed
            self.tableView.beginUpdates()
            currentlyShown.insert(contentsOf: cellDataNode.children, at: row+1)
            var paths:[IndexPath] = []
            for i in 0..<cellDataNode.children.count{
                paths.append(IndexPath(row: row+1+i, section: 0))
            }
            self.tableView.insertRows(at: paths, with: .fade)
//            self.tableView.reloadData()
            self.tableView.endUpdates()
        }
        else if(cellDataNode.hasChildren && cellDataNode.isExpanded){
            cellDataNode.isExpanded = false
            closingChildrenCount = 0
            self.tableView.beginUpdates()
            closeNodes(nodes: cellDataNode.children, startPos: row)

            let offset = row
            let rangeToRemove = offset+1 ... offset + cellDataNode.children.count
            print("Nonrecursive: \(rangeToRemove)")
            currentlyShown.removeSubrange( rangeToRemove)

            var paths:[IndexPath] = []
            for i in 0..<closingChildrenCount{
                paths.append(IndexPath(row: row+i+1, section: 0))
            }
            self.tableView.deleteRows(at: paths, with: .fade)
//            self.tableView.reloadData()
            self.tableView.endUpdates()
        }
    }

    /*
     Return height for row for indexPath.
     */
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        var height = CGFloat(0)
        let node = currentlyShown[indexPath.row]
        if node is CategoryDataNode {
            height = 100
        }
        else if node is SubjectDataNode {
            height = 75
        }
        else if node is QuizDataNode {
            height = 65
        }
        return height
    }
    
    /*
     Close any open Category and Subject nodes.
     */

    func closeNodes(nodes:[CellDataNode], startPos:Int){
        closingChildrenCount += nodes.count
        var idx = startPos
        for node in nodes {
            idx += 1
            if(node.isExpanded && node.hasChildren){
                closeNodes(nodes: node.children, startPos: idx)
                let rangeToRemove = idx+1 ... idx + node.children.count
                print("Recursive: \(rangeToRemove)")
                currentlyShown.removeSubrange(rangeToRemove)
                node.isExpanded = false
            }
        }
    }
}

/*
 Extension for transitioning to QuizSelectModeVC after selecting a QuizData node.
 */

extension ExpandableTableViewController:PerformsSegueDelegator {
    func callSegue(quizKey:String) {
        let quizSelectModeVC = self.storyboard?.instantiateViewController(withIdentifier: "quizMode") as! QuizSelectModeVC
        //TODO: add quiz key to each cell
        //quizSelectModeVC.quizKey = self.quizKey
        //Temp for testing purposes
        quizSelectModeVC.quizKey = quizKey
        self.present(quizSelectModeVC, animated: false, completion: {
        })
    }
    
    
}
