//
//  ViewController.swift
//  ImageSlider
//
//  Created by Siraj rahman on 15/10/15.
//  Copyright (c) 2015 QBurst. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ImageSliderProtocol {

    @IBOutlet weak var customImageSlider: ImageSlider!

    override func viewDidLoad() {
        super.viewDidLoad()

        customImageSlider.imageSliderDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Image Slider Protocol Methods
    
    func numberOfItems() -> Int {
        return 5
    }
    
    func imageUrlForItemAtIndexPath(indexPath: Int) -> NSURL {
        return NSURL(string: "http://jpwallhorn.com/content/images/2015/08/Coding.jpg")!
    }


}

