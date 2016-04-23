//
//  MenuDetailViewController.swift
//  KinClean
//
//  Created by user on 4/21/16.
//  Copyright © 2016 inknock. All rights reserved.
//

import UIKit
import Alamofire

class MenuDetailViewController: UIViewController , UIPickerViewDataSource, UIPickerViewDelegate{

    @IBAction func submitbtn(sender: AnyObject) {
        let parameters = [
            "cus_tel": "0874969990",
            "menu_id": (menu?.getMenuId())! + "",
            "menu_num": menu_num.description,
            "menu_des": "..."
            ]
        Alamofire.request(.POST, "http://um-project.com/projectx/index.php/example_api/preorder", parameters: parameters)
        navigationController?.popToRootViewControllerAnimated(true)
    }
    @IBOutlet weak var Navititle: UINavigationItem!
    @IBOutlet weak var menu_name: UILabel!
    @IBOutlet weak var name_thai: UILabel!
    @IBOutlet weak var menu_cost: UILabel!
    @IBOutlet weak var menu_detail: UITextView!
    @IBOutlet weak var menu_img: UIImageView!
    
    @IBOutlet weak var numberPicker: UIPickerView!
    var picData:String = ""
    
    let pickerData = [["0","1","2","3","4","5","6","7","8","9","10"]]
    var menu_num :Int = 0
    
    var menu : Menu_Object?
    
    @IBOutlet weak var totle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        Navititle.title = menu?.getMenuName()
        menu_name.text = menu?.getMenuName()
        picData = menu!.getMenuPic()
        name_thai.text = menu?.getMenuNameThai()
        menu_cost.text = menu?.getMenucost().description
        menu_cost.text = menu_cost.text! + " Bath"
        menu_detail.text = menu?.getMenuDes()
        load_image(picData)
        numberPicker.dataSource = self
        numberPicker.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView,numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "จำนวน: \(pickerData[component][row])"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int,inComponent component: Int)
    {
        updata()
    }
    
    func updata(){
        let number = pickerData[0][numberPicker.selectedRowInComponent(0)]
        menu_num = Int(number)!
        let totle_cost = menu_num*(menu?.getMenucost())!
        totle.text = "ราคารวม " + totle_cost.description + " บาท"
    }
    
    func load_image(urlString:String){
        let imgURL: NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            
            if (error == nil && data != nil)
            {
                func display_image()
                {
                    self.menu_img.image = UIImage(data: data!)
                    self.menu_img.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
                    self.view.addSubview(self.menu_img)
                }
                
                dispatch_async(dispatch_get_main_queue(), display_image)
            }
            
        }
        task.resume()
    }
    

}
