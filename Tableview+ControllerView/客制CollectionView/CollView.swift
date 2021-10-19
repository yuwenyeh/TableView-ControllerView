//
//  CollView.swift
//  Tableview+ControllerView
//
//  Created by etrovision on 2021/10/19.
//

import Foundation
import UIKit

fileprivate let placeholder:String = "ic_bannerPlace"
fileprivate let COLLCELL = "collectionViewcell"
class CollView: UICollectionView,UICollectionViewDelegate,UICollectionViewDataSource {
   
    
    var imageIndex = 0
    fileprivate var timer : Timer?
    fileprivate var bannerPageSize = 1
    var placeholderImage:String = placeholder
    fileprivate var pageControl: UIPageControl?
    fileprivate var currentIndex: NSInteger = 0
    fileprivate var bannerRotateCounterLimit:Int = 4
    
    //圖片是否是網路Url 默認 否 是的話要xcoder下載三方套件
    var isFromnet = false
   
    var imgUrls = NSArray(){
        didSet{
            pageControl?.numberOfPages = imgUrls.count
            self.reloadData()
        }
    }
    
    
    convenience init(frame:CGRect){
        self.init(frame: frame, collectionViewLayout: CollViewFlowLayout.init())
    }
    
    convenience init(frame: CGRect,imageUrls: NSArray){
        self.init(frame: frame, collectionViewLayout: CollViewFlowLayout.init())
        self.imgUrls = imageUrls
        
    }
    
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.backgroundColor = .white
        self.dataSource = self
        self.delegate = self
        self.register(CollCollectionViewCell.self, forCellWithReuseIdentifier: COLLCELL)
        
        setUpTimer()
        //負責保持UI更新
        
        DispatchQueue.main.async { [self] in
            self.setUpPagecontrol()
            let indexpath = NSIndexPath.init(row: imgUrls.count, section: 0)
            
            self.scrollToItem(at: indexpath as IndexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpPagecontrol() {
        pageControl = UIPageControl.init(frame: CGRect.init(x: 0, y: self.bounds.size.height, width: self.frame.width, height: 30))
        pageControl?.pageIndicatorTintColor = .gray//未選中的顏色
        pageControl?.currentPageIndicatorTintColor = .black//選中顏色
        pageControl?.numberOfPages = Int(ceil(Double(imgUrls.count) / Double(bannerPageSize)))//顯示數量
        pageControl?.currentPage = 0
       
        //一定要將pageControl添到superview上
        self.superview?.addSubview(pageControl!)
    }
    

    @objc private func autoScroll() {
        //当前的索引
        var offset:NSInteger = NSInteger(self.contentOffset.x / self.bounds.size.width)
        
        //第0页时，跳到索引imgUrls.count位置；最后一页时，跳到索引imgUrls.count-1位置
        if offset == 0 || offset == (imageIndex - 1) {
            if offset == 0 {
                offset = imgUrls.count
            }else {
                offset = imgUrls.count - 1
            }
            
            self.contentOffset = CGPoint.init(x: CGFloat(offset) * self.bounds.size.width, y: 0)
            //再滚到下一页
            self.setContentOffset(CGPoint.init(x: CGFloat(offset + 1) * self.bounds.size.width, y: 0), animated: true)
        }else{
            //直接滚到下一页
            self.setContentOffset(CGPoint.init(x: CGFloat(offset + 1) * self.bounds.size.width, y: 0), animated: true)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //目前原因不明
        return imgUrls.count < 0 ? imgUrls.count*1000 : 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:CollCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: COLLCELL, for: indexPath) as! CollCollectionViewCell
        
        cell.backgroundColor = .systemPink
        if imgUrls.count > 0 {
            if let urlStr = self.imgUrls[indexPath.row % imgUrls.count] as? String {
                if isFromnet {
//                    let url:URL = URL.init(string: urlStr)!
//                    cell.imageView?.sd_setImage(with: url, placeholderImage: UIImage.init(named: placeholderImage), options: SDWebImageOptions.refreshCached)
                }else{
                    cell.imageView?.image = UIImage.init(named: urlStr)
                }
            }
        }
      
        currentIndex = numberOfItems(inSection: 0)
        return cell
    }
    
    //MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    
        var offset = NSInteger(scrollView.contentOffset.x / scrollView.bounds.size.width)
        //第0页时，跳到索引imgUrls.count位置；最后一页时，跳到索引imgUrls.count-1位置
        if offset == 0 || offset == (self.numberOfItems(inSection: 0) - 1) {
            if offset == 0 {
                offset = imgUrls.count
            }else {
                offset = imgUrls.count - 1
            }
        }
        scrollView.contentOffset = CGPoint.init(x: CGFloat(offset) * scrollView.bounds.size.width, y: 0)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeTimer()
    }
    
    //滾動視圖確實結束拖動（_：將減速:)
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        setUpTimer()
    }
    
    //滾動視圖確實滾動（_:)
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
        print("開始自動時間")
        let page = NSInteger(scrollView.contentOffset.x / scrollView.bounds.size.width)
        let currentPageIndex = imgUrls.count > 0 ? page % imgUrls.count : 0
        self.pageControl?.currentPage = Int(currentPageIndex)
    }
    
    //移除計時器
    private func removeTimer(){
        timer?.invalidate()
        timer = nil
    }
    //添加計時器
    private func setUpTimer(){
        timer = Timer.init(timeInterval: 1.5, target: self, selector: #selector
                           (autoScroll), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .common)//很重要
    }
    
    deinit{removeTimer()}

}
 

class CollViewFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()//必須寫
        collectionView?.backgroundColor = .white
        self.itemSize = (self.collectionView?.bounds.size)!
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
        self.scrollDirection = .horizontal
        
        self.collectionView?.isPagingEnabled = true
        self.collectionView?.showsHorizontalScrollIndicator = false
        self.collectionView?.showsVerticalScrollIndicator = false
        self.collectionView?.backgroundColor = .white
        
    }
    
}
    class CollCollectionViewCell:UICollectionViewCell {
        var imageView : UIImageView?
      
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.clipsToBounds = true
            
            imageView = UIImageView.init(frame:CGRect(x: 120, y: 20, width:200, height: 200))
            imageView?.contentMode = .scaleAspectFill
            imageView?.image = UIImage(named: "4")
            //imageView?.layer.cornerRadius = 20
            contentView.addSubview(imageView!)
            
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

