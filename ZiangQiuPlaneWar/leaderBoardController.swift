//
//  leaderBoardController.swift
//  ZiangQiuPlaneWar
//
//  Created by Qiu Ziang on 2018/6/7.
//  Copyright © 2018年 skylove. All rights reserved.
//
import UIKit

class leaderBoardController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        print("进入页面")
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadList), name: NSNotification.Name(rawValue: "nomal"), object: nil)
        if UserDefaults.standard.object(forKey: "nomalMode") == nil {
            let arrayList = [String]()
            print("重置数据")
            UserDefaults.standard.set(arrayList, forKey: "nomalMode")
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBOutlet weak var listTableView: UITableView!
    
    @objc func reloadList(notification: NSNotification) {
        
        listTableView.reloadData()
        
    }
    
    /* To reload table view he used the code above.
     
     override func viewDidAppear(_ animated: Bool) {
     listTableView.reloadData()
     }
     
     Obs: I used the Notification center when addButton is pressed.
     
     
     
     */
  // set up count of this game 
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    
            guard let nomalListObject = UserDefaults.standard.object(forKey: "nomalMode") else {
                print("Error \(#line): Cannot access the user default array list")
                return 0
            }
        
            if let nomalList = nomalListObject as? Array<String> {
                print(nomalList)
                return nomalList.count
            } else {
                print("Error \(#line): Cannot identify the array list as a string array")
                return  0
            }
        
    }
    
    // set cell for this controller
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "leaderBoardCell")
        
        guard let arrayListObject = UserDefaults.standard.object(forKey: "nomalMode") else {
            print("Error \(#line): Cannot access the user default array list")
            return cell
        }
        
        if let arrayList = arrayListObject as? Array<String> {
            cell.textLabel?.text = arrayList[indexPath.row]
            cell.textLabel?.font = UIFont(name:"Party LET", size:30)
            
        }
        
        
       
        guard let nomalListObject = UserDefaults.standard.object(forKey: "nomalMode") else {
            print("Error \(#line): Cannot access the user default array list")
            return cell
        }
        
        if var nomalList  = nomalListObject as? Array<String> {
            nomalList.sort(by:<)
            cell.textLabel?.text = nomalList[indexPath.row]
            cell.textLabel?.font = UIFont(name:"Party LET", size:30)
            
        }
    
    return cell
    
}
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
