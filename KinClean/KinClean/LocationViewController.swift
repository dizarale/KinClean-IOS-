//
//  LocationViewController.swift
//  KinClean
//
//  Created by user on 4/22/16.
//  Copyright © 2016 inknock. All rights reserved.
//

import UIKit
import Alamofire

class LocationViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{

    @IBOutlet weak var locationPicker: UIPickerView!
    
    let timeFormatter =  NSDateFormatter()
    let location = [["DPU BUILD1","DPU BUILD2","DPU BUILD3","DPU BUILD4"]]
    
    var timeset = ""
    var locationset = ""
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBAction func timePickerChange(sender: AnyObject) {
        timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        timeFormatter.dateFormat = "HH:mm"
        print(timeFormatter.stringFromDate(timePicker.date))
        timeset = timeFormatter.stringFromDate(timePicker.date)
    }
    
    @IBAction func locationbtn(sender: AnyObject) {
        confirmOrder()
        print(timeset + " " + locationset )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationPicker.delegate = self
        locationPicker.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController!.popViewControllerAnimated(true);
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return location.count
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return location[component].count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return location[component][row]
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int,inComponent component: Int)
    {
        locationset = location[0][locationPicker.selectedRowInComponent(0)]
    }
    
    
    func confirmOrder() {
        let alert = UIAlertController(title: "Confrim Order", message: "Are you sure you want to confirm your order", preferredStyle: .ActionSheet)
        
        let ConfirmAction = UIAlertAction(title: "Confirm", style: .Destructive, handler: handleConfirm)
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelDeleteMenu)
        
        alert.addAction(ConfirmAction)
        alert.addAction(CancelAction)
        
        // Support presentation in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    func handleConfirm(alertAction: UIAlertAction!) -> Void {
        let parameters = [
            "cus_tel": "0874969990",
            "order_lat": "13.869496803814199",
            "order_long": "100.55009834468365",
            "order_time_recive": timeset,
            "order_location": locationset,
            "order_location_detail": "..."
        ]
        Alamofire.request(.POST, "http://www.um-project.com/projectx/index.php/example_api/orderConfirm", parameters:parameters)
        self.performSegueWithIdentifier("backtoMenu", sender: self)
        
    }
    func cancelDeleteMenu(alertAction: UIAlertAction!) {
    }

}
