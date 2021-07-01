//
//  Extension.swift
//  CompositePattern
//
//  Created by Дмитрий Дуденин on 01.07.2021.
//

import Foundation

func randomString(len:Int) -> String {
    let charSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let c = Array(charSet)
    var s:String = ""
    for _ in (1...10) {
        s.append(c[Int(arc4random()) % c.count])
    }
    return s
}


func RandomData() -> TaskList {
    let taskList = TaskList(name: "General")
    
    let randomCount = Int.random(in: 2...10)

    for i in 0...randomCount {
        let name = randomString(len: 10)
        
        if Bool.random() {
            taskList.addSingleTask(with: name)
        } else {
            taskList.addListTask(with: name)
            (taskList.subtasks[i] as! TaskList).addSubtaskList(generateSubtasks(with: 5))
        }
    }
    
    return taskList
}

func generateSubtasks(with depth: Int) -> [Task] {
    guard depth > 0  else { return [] }
    
    var tasks: [Task] = []
    
    let randomCount = Int.random(in: 2...5)
    
    for _ in (0...randomCount) {
        var task: Task
        let name = randomString(len: 10)
        
        if Bool.random() {
            task = TaskList(name: name)
            (task as! TaskList).addSubtaskList(generateSubtasks(with: depth - 1))
        } else {
            task = SingleTask(name: name)
        }
        
        tasks.append(task)
    }
    return tasks
}
