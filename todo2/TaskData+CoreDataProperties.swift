//
//  TaskData+CoreDataProperties.swift
//  todo2
//
//  Created by 冨平準喜 on 2015/08/14.
//  Copyright © 2015年 冨平準喜. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

extension TaskData {

    @NSManaged var task: String?
    @NSManaged var disc: String?

}
