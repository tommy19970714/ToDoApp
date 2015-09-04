//
//  ViewController.swift
//  todo2
//
//  Created by 冨平準喜 on 2015/08/14.
//  Copyright © 2015年 冨平準喜. All rights reserved.
//
import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTextField: UITextField!
    @IBOutlet weak var myButtonWrite: UIButton!
    @IBOutlet weak var myTableView: UITableView!

    
    // Tableで使用する配列を設定する.
    var myItems: [NSString] = []
    var myTimes: [NSString] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        //myTextField
        
        //myButtonWrite
        
        //myButtonRead
        
        //myTableView
        
        myTableView.delegate = self
        myTableView.dataSource = self
        // selfをデリゲートにする
        self.myTextField.delegate = self

        readData()
    }
    
    //returning to view
    override func viewWillAppear(animated: Bool) {
        myTableView.reloadData();
    }
    
    /*
    ボタンイベント
    */
    @IBAction func writeButton_Click(sender: UIButton) {
        writeData()
        myTextField.text = ""
        readData()
    }
    
    
    
    /*
    CoreDataへのデータ書き込み
    */
    func writeData(){
        // CoreDataへの書き込み処理.
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let myContext: NSManagedObjectContext = appDel.managedObjectContext
        
        let myEntity: NSEntityDescription! = NSEntityDescription.entityForName("TaskData", inManagedObjectContext: myContext)
        
        let newData = TaskData(entity: myEntity, insertIntoManagedObjectContext: myContext)
        newData.task = myTextField.text
        newData.disc = ""
        
        try! myContext.save()
    }
    
    /*
    CoreDataからのデータ読み込み.
    */
    func readData(){
        // CoreDataの読み込み処理.
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let myContext: NSManagedObjectContext = appDel.managedObjectContext
        
        let myRequest: NSFetchRequest = NSFetchRequest(entityName: "TaskData")
        myRequest.returnsObjectsAsFaults = false
        
        var myResults: NSArray!
        //var myResults: NSArray! = myContext.executeFetchRequest(myRequest, error: nil)
        
        do {
            myResults = try myContext.executeFetchRequest(myRequest)
            // success ...
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        myItems = []
        myTimes = []
        
        for myData in myResults {
            myItems.append(myData.valueForKey("task") as! String)
            myTimes.append(myData.valueForKey("disc") as! String)
            
            print(myData.valueForKey("task") as! String)
            print(myData.valueForKey("disc") as! String)
        }
        
        myTableView.reloadData()
    }
    
    func deleteData(deleteString: NSString)
    {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "TaskData")
        if let fetchResults = try!managedObjectContext.executeFetchRequest(fetchRequest) as? [TaskData] {
            for (var i=0; i<fetchResults.count; i++) {
                if fetchResults[i].task ==  deleteString{
                    managedObjectContext.deleteObject(fetchResults[i])
                    try!managedObjectContext.save()
                }
            }
        }
    }
    
    /*
    改行ボタンが押された際に呼ばれる.
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    //UITableViewDataSource
    func tableView(tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
        return myItems.count
    }
    
    //Editableの状態にする.
    func tableView(tableView: UITableView,canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "test")
        cell.textLabel?.text = myItems[indexPath.row] as String
        cell.detailTextLabel?.text = myTimes[indexPath.row] as String
        
        return cell
    }
    
    //UITableViewDelete
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        if(editingStyle == UITableViewCellEditingStyle.Delete){
            
            deleteData(myItems[indexPath.row])
            
            myItems.removeAtIndex(indexPath.row)
            myTableView.reloadData();
            
        }
        
    }
}

