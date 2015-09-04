//
//  TaskManager.swift
//  todo2
//
//  Created by 冨平準喜 on 2015/08/14.
//  Copyright © 2015年 冨平準喜. All rights reserved.
//

import UIKit

var taskMgr: TaskManager = TaskManager()

struct task {
    var name = "Un-Named"
    var desc = "Un-Described"
}

class TaskManager: NSObject {
    
    var tasks : [task] = []
    
    func addTask(name: String, desc: String){
        tasks.append(task(name: name, desc: desc))
    }
}
