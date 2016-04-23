//
//  ViewController.swift
//  KinClean
//
//  Created by user on 4/11/16.
//  Copyright © 2016 inknock. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    @IBOutlet var collectionView: UICollectionView!
    
    var menus : [Menu_Object] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        loadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        //return self.name.count
        return menus.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell
        
        let urlString = self.menus[indexPath.row].getMenuPic()
        let imgURL: NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            
            if (error == nil && data != nil)
            {
                func display_image()
                {
                    cell.imgCell?.image = UIImage(data: data!)
                }
                
                dispatch_async(dispatch_get_main_queue(), display_image)
            }
            
        }
        
        task.resume()
        
        //cell.lblCell?.text = self.name[indexPath.row]
        cell.lblCell?.text = self.menus[indexPath.row].getMenuNameThai()
    
        return cell
        
    }
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let kWhateverHeightYouWant = 250
        return CGSizeMake(collectionView.bounds.size.width-10, CGFloat(kWhateverHeightYouWant))
    }
    override func unwindForSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print(unwindSegue.identifier)
    }
    
    func loadData() {
        Alamofire.request(.GET, "http://www.um-project.com/projectx/index.php/example_api/menu", parameters: ["sub": "1"])
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
                    for i in 0...rowData {
                        let menu_id = json[i]["menu_id"].stringValue
                        let menu_name = json[i]["menu_name"].stringValue
                        let menu_name_thai = json[i]["menu_name_thai"].stringValue
                        let menu_pic = json[i]["menu_pic"].stringValue
                        let menu_cost = json[i]["menu_cost"].stringValue
                        let menu_des = json[i]["menu_des"].stringValue
                        
                        
                        let menu = Menu_Object(menu_id:menu_id,menu_name:menu_name,menu_name_thai:menu_name_thai,menu_pic:menu_pic,menu_cost:menu_cost,menu_des:menu_des)
                        self.menus.append(menu)
                    }
                    print(self.menus)
                    self.collectionView.reloadData()
                }
                
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        self.performSegueWithIdentifier("showDetail", sender: self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail"{
            let indexPaths = self.collectionView!.indexPathsForSelectedItems()!
            let indexPath = indexPaths[0] as NSIndexPath
            let vc = segue.destinationViewController as! MenuDetailViewController
            vc.menu = self.menus[indexPath.row]
        }
    }


}

