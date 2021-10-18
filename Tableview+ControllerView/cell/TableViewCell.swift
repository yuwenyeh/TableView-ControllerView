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
   // var bannerRotateCounter: Int = 0
    var bannerRotateCounterLimit : Int = 4
    let width = UIScreen.main.bounds.width
    
  
    var currentIndex: NSInteger = 0
   
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
         let pageControl = UIPageControl(frame: CGRect(x: 0, y: 150, width: width , height: 50))
         
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.black
        pageControl.numberOfPages = Int(ceil(Double(imageArray.count) / Double(bannerPageSize)))
        pageControl.currentPageIndicatorTintColor = .black//已選取的顏色
        pageControl.pageIndicatorTintColor = UIColor.gray;//未選取的顏色
        pageControl.hidesForSinglePage = true
         return pageControl;
     }()

 
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupController()
        setupTimer()
    
    
    }
    
    func setupController() {
         // 設置數據
        collectionView.register(UINib(nibName:"CollectionViewCell", bundle:nil),
                                forCellWithReuseIdentifier:"CollectionViewCell")
         collectionView.reloadData()
         collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: false)
         
         self.addSubview(pageControl)
     }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print(indexPath.item)
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
    
//    @objc func changeBanner(){
//
//       let indexPath: IndexPath = IndexPath(item: imageIndex, section: 0)
//        if imageIndex == imageArray.count
//        {
//            imageIndex = 0
//            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
//            changeBanner()
//        }else{
//              //可控制捲動到某一個cell
//            imageIndex = imageIndex + 1
//            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//        }
//        imageIndex = imageIndex % imageArray.count
//        pageControl.currentPage = (imageIndex - 1 + imageArray.count) % imageArray.count
//
//    }
    
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
          if (imageArray.count == 0) {
              return 0
          }
         // return imageArray.count + 2
        return imageArray.count
      }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
       
        if (indexPath.row == self.imageArray.count){
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
        cycleScroll()
        setupTimer()
        print("開始自動時間")
        
//        if (scrollView.contentOffset.x == 0){
//
//            scrollView.contentOffset = CGPoint(x: CGFloat(self.imageArray.count) * width, y: 0)
//            self.pageControl.currentPage = self.imageArray.count
//
//            //當 UIScrollVIew滑動到最後一位停止時，將UIScrollerVIew的偏移位置改變
//        }else if (scrollView.contentOffset.x == CGFloat(self.imageArray.count + 1) * width){
//            scrollView.contentOffset = CGPoint(x: width, y: 0)
//            self.pageControl.currentPage = 0
//
//        }
//        self.pageControl.currentPage = (currentIndex - 1 + imageArray.count) % imageArray.count
     
    }
    
    func cycleScroll(){
        let page = collectionView.contentOffset.x / collectionView.bounds.size.width
        if (page == 0){//滾到左邊
            print("滾到左邊")
            collectionView.contentOffset = CGPoint(x: collectionView.bounds.size.width * CGFloat((imageArray.count) - 2), y: 0)
            pageControl.currentPage = (imageArray.count) - 2
          
            
        }else if (page == CGFloat(imageArray.count) - 1) {//滾到右邊
            collectionView.contentOffset = CGPoint(x: collectionView.bounds.size.width, y: 0)
            pageControl.currentPage = 0
            print("滾到右邊")
        } else {
            pageControl.currentPage = Int(page) - 1
        }
    }
    
    
    
}
