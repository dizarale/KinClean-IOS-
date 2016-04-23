//
//  Menu_Object.swift
//  KinClean
//
//  Created by user on 4/12/16.
//  Copyright © 2016 inknock. All rights reserved.
//

class Menu_Object{
    var menu_id : String?
    var menu_name : String?
    var menu_name_thai : String?
    var menu_pic : String?
    var menu_cost : Int?
    var menu_des : String?
    var menu_num : String?
    init(){
        
    }
    init(menu_id:String ,menu_name:String,menu_name_thai:String,menu_pic:String,menu_cost:String,menu_des:String) {
        self.menu_id = menu_id
        self.menu_name = menu_name
        self.menu_name_thai = menu_name_thai
        self.menu_pic = menu_pic
        self.menu_cost = Int(menu_cost)
        self.menu_des = menu_des
    }
    func setMenuId(menu_id:String) {
        self.menu_id = menu_id
    }
    func setMenuName(menu_name:String,menu_name_thai:String){
        self.menu_name = menu_name
        self.menu_name_thai = menu_name_thai
        
    }
    func setMenuPic(menu_pic:String) {
        self.menu_pic = menu_pic
    }
    func setMenuCost(menu_cost:Int) {
        self.menu_cost = menu_cost
    }
    func setMenuDes(menu_des:String) {
        self.menu_des = menu_des
    }
    func setMenuNum(menu_num:String) {
        self.menu_num = menu_num
    }
    func getMenuId() -> String {
        return self.menu_id!
    }
    func getMenuName() -> String {
        return self.menu_name!
    }
    func getMenuNameThai() -> String {
        return self.menu_name_thai!
    }
    func getMenuPic() -> String {
        return self.menu_pic!
    }
    func getMenucost() -> Int {
        return self.menu_cost!
    }
    func getMenuDes() -> String {
        return self.menu_des!
    }
    func getMenuNum() -> String {
        return self.menu_num!
    }
}