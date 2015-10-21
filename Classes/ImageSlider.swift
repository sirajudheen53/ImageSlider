//
//  ImageSlider.swift
//  
//
//  Created by Siraj rahman on 15/10/15.
//
//

import UIKit


@objc protocol ImageSliderProtocol : NSObjectProtocol {
    func numberOfItems() -> Int
    func imageUrlForItemAtIndexPath(indexPath : Int) -> NSURL

    optional func didSelectedImageAtIndex(indexPath : Int, imageUrl : NSURL?)
}


class ImageSlider: UIView, UIScrollViewDelegate {
    
    var imageSliderDelegate: ImageSliderProtocol? {
        didSet {
            self.setupViewElements()
        }
    }
    var numberOfItems : Int!
    var sliderImageViews = [CustomImageView]()
    var pageNumber = 0
    
    var contentScrollView : UIScrollView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.blackColor()
    }
    
    //MARK: - Private Methods
    func setupViewElements() {
        self.numberOfItems = self.imageSliderDelegate!.numberOfItems()

        self.setupContentScrollView()
        self.setupContentImageViews()
        
        //Load first image to the showing imageview
        let initialImageView = self.sliderImageViews.first
        let initialImageUrl = self.imageSliderDelegate?.imageUrlForItemAtIndexPath(self.pageNumber)
        initialImageView!.loadImageWithUrl(initialImageUrl!, placeHolderImage: nil, showActivityView: true)
    }
    
    func setupContentScrollView() {
        //Create and setup content scrollview
        self.contentScrollView = UIScrollView()
        self.contentScrollView?.pagingEnabled = true
        self.contentScrollView?.delegate = self
        self.contentScrollView?.contentSize = CGSize(width: self.frame.size.width * CGFloat(self.numberOfItems!), height: self.frame.size.height)
        self.contentScrollView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.contentScrollView!)
        self.addConstraintsForContentScrollView(self.contentScrollView!, superView: self)
    }
    
    func setupContentImageViews() {
        //Create ImageViews and Subivew it to ScrollView
        
        for _ in 0..<self.numberOfItems {
            let imageView = CustomImageView()
            self.contentScrollView?.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.layer.borderWidth = 2.0
            imageView.layer.borderColor = UIColor.blackColor().CGColor
            sliderImageViews.append(imageView)
        }
        self.addConstraintsContentImageViews(self.contentScrollView!, imageViews: self.sliderImageViews)
    }
    
    func addConstraintsForContentScrollView(contentScrollView : UIScrollView, superView : UIView) {
        let views = ["contentScrollView" : contentScrollView]
        superView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[contentScrollView]|", options: [], metrics: nil, views: views))
        superView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[contentScrollView]|", options: [], metrics: nil, views: views))
    }
    
    func addConstraintsContentImageViews(contentScrollView : UIScrollView, imageViews : [CustomImageView]) {
        var horizontalConstraintFormat = "H:|"
        
        var views : [String : UIView] = ["contentScrollView" : contentScrollView]
        for index in 0..<imageViews.count {
            print("Index \(index)\n")
            let imageview = imageViews[index]
            views["imageview\(index)"] = imageview
            horizontalConstraintFormat += "[imageview\(index)(==contentScrollView)]"
            contentScrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[imageview\(index)(==contentScrollView)]|", options: [], metrics: nil, views: views))
         }
        horizontalConstraintFormat += "|"
        contentScrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(horizontalConstraintFormat, options: [], metrics: nil, views: views))
    }
    
    //MARK: - UIScrollView Delegate Methods
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let fractionalPage = scrollView.contentOffset.x / pageWidth
        let page = Int(fractionalPage)
        if self.pageNumber != page {
            self.pageNumber = page
            let imageUrl = self.imageSliderDelegate!.imageUrlForItemAtIndexPath(self.pageNumber)
            let currentlyShowingImageView = self.sliderImageViews[self.pageNumber]
            currentlyShowingImageView.loadImageWithUrl(imageUrl, placeHolderImage: nil, showActivityView: true)
        }
     }
}
