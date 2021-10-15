//
//  TableViewCell.swift
//  Tableview+ControllerView
//
//  Created by etrovision on 2021/10/7.
//

import UIKit

class TableViewCell: UITableViewCell{
  

  
    var imageIndex = 0
    let width = UIScreen.main.bounds.width
    
    var leftImageView = UIImageView()
    var rightImageView = UIImageView()
    var currentImageView = UIImageView()
  
    var currentIndex: NSInteger = 0
    var timer = Timer()
    let imageArray :[String] =
    {
        var arr = [UIImage]()
        let imageList = ["1","2","3","4"]
        return imageList
    }()
    
    lazy var collectionView: UICollectionView = {
         let flowLayout = UICollectionViewFlowLayout()
         flowLayout.minimumLineSpacing = 0
         flowLayout.minimumInteritemSpacing = 0
         flowLayout.scrollDirection = .horizontal
         flowLayout.itemSize = CGSize(width: width, height: 200)
         
         let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200), collectionViewLayout: flowLayout)
         
         collectionView.isPagingEnabled = true
         collectionView.showsHorizontalScrollIndicator = false
         collectionView.backgroundColor = UIColor.white
         collectionView.delegate = self
         collectionView.dataSource = self
        collectionView.register(UINib(nibName:"CollectionViewCell", bundle:nil),
                                forCellWithReuseIdentifier:"CollectionViewCell")
         self.addSubview(collectionView)
         
         return collectionView
     }()
    
    
    lazy var pageControl: UIPageControl = {
         let pageControl = UIPageControl(frame: CGRect(x: 0, y: 150, width: width , height: 50))
         
         pageControl.numberOfPages = self.imageArray.count
         pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .black//已選取的顏色
        
         pageControl.tintColor = UIColor.black
         pageControl.pageIndicatorTintColor = UIColor.gray;//未選取的顏色
         
         return pageControl;
     }()

 
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupController()
        
       Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(changeBanner), userInfo: nil, repeats: true)
    
    }
    
    func setupController() {
         /// 設置數據
        collectionView.register(UINib(nibName:"CollectionViewCell", bundle:nil),
                                forCellWithReuseIdentifier:"CollectionViewCell")
         collectionView.reloadData()
         collectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .left, animated: false)
         
         self.addSubview(pageControl)
     }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("collectionView.indexpath :",indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
    }
    
    
    @objc func changeBanner(){
        
        imageIndex = imageIndex +  1
        imageIndex = imageIndex % imageArray.count
        let indexPath: IndexPath = IndexPath(item: imageIndex, section: 0)
   
        //imageIndex = (imageIndex - 1 + imageArray.count) % imageArray.count
        if imageIndex < (imageArray.count - 1)
        {
//            //可控制捲動到某一個cell
           collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)

        }else if imageIndex == imageArray.count
        {
            imageIndex = 0
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            changeBanner()
        }
        
        imageIndex = imageIndex % imageArray.count
        pageControl.currentPage = (imageIndex - 1 + imageArray.count) % imageArray.count
    }
    

    
 

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    }

extension TableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          /// 這步只是防止崩潰
          if (imageArray.count == 0) {
              return 0
          }
          return imageArray.count + 2
      }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
      
        if (indexPath.row == 0){
            Cell.imageName =  imageArray.last!
        }else if (indexPath.row == self.imageArray.count + 1){
            
           Cell.imageName = imageArray.first
        }else {
            Cell.imageName = imageArray[indexPath.row - 1]
        }
       
        return Cell
    }
    
}
extension TableViewCell: UICollectionViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if (scrollView.contentOffset.x == 0){
            scrollView.contentOffset = CGPoint(x: CGFloat(self.imageArray.count) * width, y: 0)
            self.pageControl.currentPage = self.imageArray.count
            //當 UIScrollVIew滑動到最後一位停止時，將UIScrollerVIew的偏移位置改變
 
        }else if (scrollView.contentOffset.x == CGFloat(self.imageArray.count + 1) * width){
            scrollView.contentOffset = CGPoint(x: width, y: 0)
            self.pageControl.currentPage = 0
        }else {
            self.pageControl.currentPage = Int(scrollView.contentOffset.x / width ) - 1
        }
                    
    }
    
}
