//
//  CustomImageView.swift
//  
//
//  Created by Siraj rahman on 16/10/15.
//
//

import UIKit

class CustomImageView: UIImageView {
    var activityIndicator : UIActivityIndicatorView?
    
    func showActivityIndicator() {
        if let activityViewUnwrapped = self.activityIndicator {
            activityViewUnwrapped.hidden = false
        } else {
            self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            self.activityIndicator!.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(self.activityIndicator!)
            self.activityIndicator!.startAnimating()
            
            //Add constraints
            let views = ["activityIndicatorView" : self.activityIndicator!, "imageView" : self]
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[imageView]-(<=1)-[activityIndicatorView]", options:NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: views))
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[imageView]-(<=1)-[activityIndicatorView]", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: views))
        }
    }
    
    func hideActivityView() {
        self.activityIndicator?.hidden = true
    }
    
    func loadImageWithUrl(url : NSURL, placeHolderImage : UIImage?, showActivityView : Bool) {
        self.showActivityIndicator()
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.addValue("image/*", forHTTPHeaderField: "Accept")
        self.setImageWithUrlRequest(request,
            placeHolderImage: placeHolderImage,
            success: { (request, response, image, fromCache) -> Void in
                self.image = image
                self.hideActivityView()
        }) { (request, response, error) -> Void in
            self.image = placeHolderImage
            self.hideActivityView()
        }
    }
    
    
}
