//
//  CoverCell.swift
//  Tableview+ControllerView
//
//  Created by etrovision on 2021/10/19.
//

import UIKit

class CoverCell: UITableViewCell {

    
    fileprivate lazy var imageDataSource = NSArray()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imageDataSource = loadImages()
        let scrollView = CollView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200), imageUrls: imageDataSource)
        
        self.addSubview(scrollView)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadImages()-> NSArray {
        return ["1","2","3","4"]
    }
}
