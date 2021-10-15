//
//  CollectionViewCell.swift
//  Tableview+ControllerView
//
//  Created by etrovision on 2021/10/7.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {


    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       //setupCell()
    }
  
    /// 顯示的圖片
       let imageView = UIImageView()
       var imageName: String? = "" {
           didSet {
               if let name = imageName {
                   image.image = UIImage(named: name)
               }
           }
       }

       
       /// 初始化視圖
       func setupCell() {
           imageView.frame = self.bounds
           contentView.addSubview(imageView)
       }
       

       
}
