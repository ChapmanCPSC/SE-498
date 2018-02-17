//
//  ExapandableTableViewController.swift
//  ExpandableTable
//
//  Created by Harnack, Paul (Student) on 2/15/18.
//  Copyright © 2018 Harnack, Paul (Student). All rights reserved.
//

import UIKit

class ExpandableTableViewController: UITableViewController {

    var cellDataNodes:[CellDataNode]!
    var currentlyShown:[CellDataNode]!
    // TODO figure out a way to make an array of cell types so that user doesn't have to add if statements to cast
    // var cellTypes:[CellType.Type] = [CategoryTableViewCell.self]

    func getCellData() {
        cellDataNodes = []
        currentlyShown = []

        cellDataNodes.append(
                CategoryDataNode(categoryName: "Therapeutics", children: [
                    SubjectDataNode(subjectName: "Cardiology", children: [], completionEvents: []),
                    SubjectDataNode(subjectName: "Endocrinology", children: [], completionEvents: []),
                    SubjectDataNode(subjectName: "Renal", children: [
                        QuizDataNode(quizName: "Quiz 1", children: [], completionEvents: []),
                        QuizDataNode(quizName: "Quiz 2", children: [], completionEvents: []),
                        QuizDataNode(quizName: "Quiz 3", children: [], completionEvents: []),
                        QuizDataNode(quizName: "Quiz 4", children: [], completionEvents: []),
                        QuizDataNode(quizName: "Quiz 5", children: [], completionEvents: []),
                        QuizDataNode(quizName: "Quiz 6", children: [], completionEvents: []),
                        QuizDataNode(quizName: "Quiz 7", children: [], completionEvents: []),
                        QuizDataNode(quizName: "Quiz 8", children: [], completionEvents: []),
                        QuizDataNode(quizName: "Quiz 9", children: [], completionEvents: [])
                    ], completionEvents: [])
                ], completionEvents: [])
        )
        cellDataNodes.append(
                CategoryDataNode(categoryName: "Basic Science", children: [], completionEvents: [])
        )
        cellDataNodes.append(
                CategoryDataNode(categoryName: "Biology", children: [], completionEvents: [])
        )
        cellDataNodes.append(
                CategoryDataNode(categoryName: "Chemistry", children: [], completionEvents: [])
        )

        currentlyShown.append(contentsOf: cellDataNodes)
    }

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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let cellDataNode:CellDataNode = currentlyShown[row]

        cellDataNode.completionEvents.forEach { event in event() }

        if(cellDataNode.hasChildren && !cellDataNode.isExpanded){
            cellDataNode.isExpanded = true
            // TODO figure out if begin/endUpdates is needed
//            self.tableView.beginUpdates()
            currentlyShown.insert(contentsOf: cellDataNode.children, at: row+1)
            self.tableView.reloadData()
//            self.tableView.endUpdates()
        }
        else if(cellDataNode.hasChildren && cellDataNode.isExpanded){
            cellDataNode.isExpanded = false
//            self.tableView.beginUpdates()
            closeNodes(nodes: cellDataNode.children, startPos: row)

            let offset = row
            let rangeToRemove = offset+1 ... offset + cellDataNode.children.count
            print("Nonrecursive: \(rangeToRemove)")
            currentlyShown.removeSubrange( rangeToRemove)

            self.tableView.reloadData()
//            self.tableView.endUpdates()
        }
    }

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

    func closeNodes(nodes:[CellDataNode], startPos:Int){
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

extension ExpandableTableViewController:PerformsSegueDelegator {
    func callSegue() {
        self.performSegue(withIdentifier: "QuizStartSegue", sender: nil)
    }
    
    
}
