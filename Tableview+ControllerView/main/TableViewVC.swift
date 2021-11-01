//
//  TableViewVC.swift
//  Tableview+ControllerView
//
//  Created by etrovision on 2021/10/7.
//

import UIKit

class TableViewVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        let Nib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(Nib, forCellReuseIdentifier: "TableViewCell")
        
        let CoverNib = UINib(nibName: "CoverCell", bundle: nil)
        tableView.register(CoverNib, forCellReuseIdentifier: "CoverCell")
    }



}

extension TableViewVC:UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.size.height / 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
//        switch section{
//        case 0:
//            return 1
//        case 1:
//            return 1
//        case 2:
//             return 1
//        case 3:
//            return 1
//        default:
//            return 1
//    }
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier:"CoverCell" , for: indexPath) as! CoverCell
            
            return cell
        }else{
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        
        return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "人氣嚴選"
        case 1:
            return "旅遊"
        case 2:
            return "分類"
        case 3:
            return "記事"
        default:
            return ""
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
            return 2
      
    }
 
    
}
