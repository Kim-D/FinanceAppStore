//
//  DetailViewController.swift
//  FinanceAppStore
//
//  Created by JohnKim on 2017. 11. 25..
//  Copyright © 2017년 KimD. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var detailInfo: LookUp!
    var isFirstTime = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if (isFirstTime) {
            isFirstTime = false
            
            let scrollView = self.view.subviews[0] as! UIScrollView
            let topView = scrollView.subviews[0]
            let iconImageView = topView.subviews[0] as! UIImageView
            iconImageView.layer.cornerRadius = 15.0
            iconImageView.layer.borderWidth = 1.0
            iconImageView.layer.borderColor = UIColor(red: 193.0/255.0, green: 193.0/255.0, blue: 193.0/255.0, alpha: 1.0).cgColor
            NetworkHelper.networkHelper.downloadImageWithUrl(imageUrl: detailInfo.results[0].artworkUrl100) { (image) in
                if let downloadImage = image {
                    iconImageView.image = downloadImage;
                }
            }
            
            let title = topView.subviews[1] as! UILabel
            title.text = detailInfo.results[0].trackCensoredName
            
            let grade = topView.subviews[2] as! UILabel
            grade.layer.borderWidth = 1.0
            grade.layer.borderColor = UIColor.black.cgColor
            grade.text = "  \(detailInfo.results[0].trackContentRating)  "
            
            let sellerName = topView.subviews[3] as! UILabel
            sellerName.text = "\(detailInfo.results[0].sellerName)>"
            
            
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
