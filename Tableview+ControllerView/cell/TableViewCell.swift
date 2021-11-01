//
//  TableViewCell.swift
//  Tableview+ControllerView
//
//  Created by etrovision on 2021/10/7.
//

import UIKit

class TableViewCell: UITableViewCell{

    var imageIndex = 0
    var timer : Timer?
    var bannerPageSize:Int = 1
    var bannerRotateCounterLimit : Int = 4
    let width = UIScreen.main.bounds.width

   
    let imageArray :[String] =
    {
        let imageList = ["1","2","3","4"]
        return imageList
    }()
    
    
    lazy var collectionView: UICollectionView = {
         let flowLayout = UICollectionViewFlowLayout()
         flowLayout.minimumLineSpacing = 0
         flowLayout.minimumInteritemSpacing = 0
         flowLayout.scrollDirection = .horizontal
         flowLayout.itemSize = CGSize(width: width, height: 200)
         
         let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: width, height: 200), collectionViewLayout: flowLayout)
         
         collectionView.isPagingEnabled = true//為了實現UICollectionView的分頁
         collectionView.showsHorizontalScrollIndicator = false
         collectionView.showsVerticalScrollIndicator = false
         collectionView.backgroundColor = UIColor.white
         collectionView.delegate = self
         collectionView.dataSource = self
         collectionView.register(UINib(nibName:"CollectionViewCell", bundle:nil),
                               forCellWithReuseIdentifier:"CollectionViewCell")
         self.addSubview(collectionView)
         
         return collectionView
     }()
    
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl(frame: CGRect(x:0, y:self.bounds.size.height , width: self.frame.width , height: 30))
         
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.black
        pageControl.numberOfPages = Int(ceil(Double(imageArray.count) / Double(bannerPageSize)))//ceil用來取餘數
        pageControl.currentPageIndicatorTintColor = .black//已選取的顏色
        pageControl.pageIndicatorTintColor = UIColor.gray;//未選取的顏色
        pageControl.hidesForSinglePage = true
         return pageControl
     }()

 
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupController()
        setupTimer()
  
    }
    
    func setupController() {
         // 設置數據
         collectionView.reloadData()
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredVertically, animated: false)
         
         self.addSubview(pageControl)
     }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
       
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
       //print("collectionView :",indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print(indexPath.item)
    }
    
    func setupTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(rotateBanner), userInfo: nil, repeats: true)
        }
      
    }
    
    
    @objc func rotateBanner() {
        imageIndex += 1
        if imageIndex < bannerRotateCounterLimit {
            return
        }
        
       imageIndex = 0
        
        var isAnimated: Bool = true
        var gotoIndx:Int = pageControl.currentPage + 1
        if gotoIndx >= imageArray.count {
            isAnimated = false
            gotoIndx = 0
        }
        
        let indexPath: IndexPath = IndexPath(item: gotoIndx, section: 0)
        pageControl.currentPage = gotoIndx
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: isAnimated)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    }

extension TableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          /// 這步只是防止崩潰
        //return imageArray.count < 0 ? imageArray.count*1000 : 6會閃退
       return imageArray.count == 0 ? 0 : imageArray.count
      }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
       
        if (indexPath.row == 0){
           Cell.imageName = imageArray.first
        }else {
           Cell.imageName = imageArray[indexPath.row]
        }
    
        return Cell
    }
    
}
extension TableViewCell: UICollectionViewDelegate {
  
    
    //手動介入觸發func 順序
    //1
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer?.invalidate()
        timer = nil
      
        print("停止自動時間")
    }
    
    //2
    //將開始停止拖移的時候執行
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    }
    
    //5
    //減速停止的時候開始執行
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
 
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        setupTimer()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      
        let page = collectionView.contentOffset.x / collectionView.bounds.size.width
        pageControl.currentPage = Int(page)
    }
}
