//
//  TasksTableViewController.swift
//  CompositePattern
//
//  Created by Дмитрий Дуденин on 01.07.2021.
//

import UIKit

protocol UpdateTaskDelegate: AnyObject {
    func updateTask(at index: Int, task item: Task)
}

class TasksTableViewController: UITableViewController {
    
    var task: Task = RandomData()
    var taskID = -1
    
    weak var taskDelegate: UpdateTaskDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.taskDelegate?.updateTask(at: taskID, task: self.task)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = self.task.name
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.task.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        
        // Configure the cell...
        let task = self.task.subtasks[indexPath.row]
        cell.textLabel?.text = task.name
        
        if task is TaskList {
            cell.detailTextLabel?.text = "\(task.count)"
        } else {
            cell.detailTextLabel?.text = "-"
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "TaskScreenID") as? TasksTableViewController else {
            return
        }
        
        vc.task = self.task.subtasks[indexPath.row]
        vc.taskID = indexPath.row
        vc.taskDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let list = self.task as? TaskList {
                list.removeTask(at: indexPath.row)
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func addTaskButtonHandler(_ sender: Any) {
        let alertController = UIAlertController(
            title: "New task",
            message: "Please input task name:",
            preferredStyle: .alert
        )
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let textFields = alertController.textFields,
                  textFields.count > 0,
                  let taskName = textFields[0].text,
                  !taskName.isEmpty
            else { return }
            
            self?.addNewTask(with: taskName)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addTextField { textField in textField.placeholder = "Task name" }
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func addNewTask(with name: String) {
        if self.task is SingleTask {
            self.task = TaskList(name: self.task.name)
        }
        
        (self.task as! TaskList).addSingleTask(with: name)
        self.tableView.reloadData()
    }
}

extension TasksTableViewController: UpdateTaskDelegate {
    func updateTask(at index: Int, task item: Task) {
        if self.task is TaskList {
            (self.task as! TaskList).subtasks[index] = item
            self.tableView.reloadData()
        }
    }
}
