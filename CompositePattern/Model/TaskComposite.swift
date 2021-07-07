//
//  TaskComposite.swift
//  CompositePattern
//
//  Created by Дмитрий Дуденин on 01.07.2021.
//

import Foundation

protocol Task {
    var name: String { get }
    var subtasks: [Task] { get }
    var count: Int { get }
}

class SingleTask: Task {
    
    var name: String
    var subtasks: [Task] = []
    var count: Int {
        return self.subtasks.count
    }
    
    init(name: String) {
        self.name = name
    }
}

class TaskList: Task {

    var name: String
    var subtasks: [Task] = []
    
    var count: Int {
        return self.subtasks.count
    }
    
    init(name: String) {
        self.name = name
    }
        
    func addSingleTask(with taskName: String) {
        self.subtasks.append(SingleTask(name: taskName))
    }
    
    func removeTask(at index: Int) {
        self.subtasks.remove(at: index)
    }
    
    func addListTask(with taskName: String) {
        self.subtasks.append(TaskList(name: taskName))
    }
    
    func addSubtaskList(_ list: [Task]) {
        self.subtasks = list
    }
}
