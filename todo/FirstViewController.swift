//
//  FirstViewController.swift
//  todo
//
//  Created by 冨平準喜 on 2015/08/13.
//  Copyright © 2015年 冨平準喜. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblTask: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tblTask.delegate = self
        tblTask.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //returning to view
    override func viewWillAppear(animated: Bool) {
        tblTask.reloadData();
    }
    
    

    
    //UITableViewDataSource
    func tableView(tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
        return taskMgr.tasks.count
    }
    
    //Editableの状態にする.
    func tableView(tableView: UITableView,canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "test")
        cell.textLabel?.text = taskMgr.tasks[indexPath.row].name
        cell.detailTextLabel?.text = taskMgr.tasks[indexPath.row].desc
        
        return cell
    }
    
    //UITableViewDelete
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
            if(editingStyle == UITableViewCellEditingStyle.Delete){
                taskMgr.tasks.removeAtIndex(indexPath.row)
                tblTask.reloadData();

            }

    }

}


