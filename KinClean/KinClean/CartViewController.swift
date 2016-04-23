//
//  CartViewController.swift
//  KinClean
//
//  Created by user on 4/22/16.
//  Copyright © 2016 inknock. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CartViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    @IBAction func cartbtn(sender: AnyObject) {
    }
    
    
    @IBOutlet weak var tableViewController: UITableView!
    
    @IBOutlet weak var ordertotle: UILabel!
    var menus : [Menu_Object] = []
    var order_cost = 0
    var deleteIndexPath: NSIndexPath? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewController.delegate = self
        tableViewController.dataSource = self
        //loadData()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        menus = []
        order_cost = 0
        loadData()
    }
    override func viewWillDisappear(animated: Bool) {
        menus = []
        order_cost = 0
        self.tableViewController.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableViewController.dequeueReusableCellWithIdentifier("cartcell", forIndexPath: indexPath) as! CartTableViewCell
        cell.menu_name?.text = menus[indexPath.row].getMenuName() + "(" + menus[indexPath.row].getMenucost().description + " X " + menus[indexPath.row].getMenuNum() + ")"
        let cost = menus[indexPath.row].getMenucost() * Int(menus[indexPath.row].getMenuNum())!
        cell.menu_cost?.text = cost.description
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            deleteIndexPath = indexPath
            let menuToDelete = menus[indexPath.row]
            confirmDelete(menuToDelete)
        }
    }

    func loadData() {
        self.menus = []
        self.order_cost = 0
        Alamofire.request(.GET, "http://www.um-project.com/projectx/index.php/example_api/preorder", parameters: ["cus_tel": "0874969990"])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                if let Json = response.result.value {
                    print("JSON: \(Json)")
                    let json = JSON(Json)
                    print("-------------")
                    print(json.count)
                    let rowData = json.count-1
                    if rowData >= 0 {
                        for i in 0...rowData {
                            let menu_id = json[i]["menu_id"].stringValue
                            let menu_name = json[i]["menu_name"].stringValue
                            let menu_pic = json[i]["menu_pic"].stringValue
                            let menu_cost = json[i]["menu_cost"].stringValue
                            let menu_des = json[i]["menu_des"].stringValue
                            let menu_num = json[i]["menu_num"].stringValue
                            
                            let menu = Menu_Object()
                            menu.setMenuId(menu_id)
                            menu.setMenuName(menu_name, menu_name_thai: " ")
                            menu.setMenuPic(menu_pic)
                            menu.setMenuCost(Int(menu_cost)!)
                            menu.setMenuDes(menu_des)
                            menu.setMenuNum(menu_num)
                            
                            let cost = Int(menu_cost)! * Int(menu_num)!
                            self.order_cost = self.order_cost + cost
                            
                            self.menus.append(menu)
                        }
                    }
                    self.tableViewController.reloadData()
                    self.ordertotle.text = "รวม : " + self.order_cost.description + " บาท"
                }
                
        }
        
    }
    func confirmDelete(menu: Menu_Object) {
        let alert = UIAlertController(title: "Delete Menu", message: "Are you sure you want to permanently delete \(menu.getMenuName())?", preferredStyle: .ActionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: handleDeleteMenu)
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelDeleteMenu)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        // Support presentation in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    func handleDeleteMenu(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteIndexPath {
            
            Alamofire.request(.POST, "http://um-project.com/projectx/index.php/example_api/preorderdel"
                , parameters: [ "cus_tel" : "0874969990",
                                "menu_id" : menus[indexPath.row].getMenuId() ])
            tableViewController.beginUpdates()
            
            menus.removeAtIndex(indexPath.row)
            
            // Note that indexPath is wrapped in an array:  [indexPath]
            tableViewController.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
            deleteIndexPath = nil
            tableViewController.endUpdates()
        }
        loadData()
    }
    
    func cancelDeleteMenu(alertAction: UIAlertAction!) {
        deleteIndexPath = nil
    }

    
}
