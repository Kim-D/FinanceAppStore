//
//  ListViewController.swift
//  FinanceAppStore
//
//  Created by JohnKim on 2017. 11. 25..
//  Copyright © 2017년 KimD. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var titleHeight: NSLayoutConstraint!
    var isSelected: Bool = false;
    
    
    var listItems: Array<AppInfo> = Array<AppInfo>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self;
        tableView.dataSource = self;
        perform(#selector(ListViewController.getFinanceFreeAppList), with: nil, afterDelay: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @objc
    func getFinanceFreeAppList() {
        NetworkHelper.networkHelper.topFinanceFreeApplications(successHandler: { (result) in
            if let feed = result! as? Feed  {
                print("==== feed entry count - ", feed.entry.count)
                self.listItems = feed.entry
                self.tableView.reloadData()
            }
        }) { (code, message) in
            print("====== getFinanceFreeAppList fail - ", message)
        }
    }
    
    func getFinanceFreeAppDetail(appId: String) {
        NetworkHelper.networkHelper.lookupWithId(id: appId, successHandler: { (result) in
            if let lookup = result! as? LookUp {
                print("\(lookup.results[0].trackCensoredName)");
                self.goToFinanceFreeAppDetailView(detailInfo: lookup)
            }
            self.isSelected = false
        }) { (code, message) in
            print("====== getFinanceFreeAppDetail fail - ", message)
            self.isSelected = false
        }
    }
    
    func getTitleLabelHeightDiff(indexPath: IndexPath) -> CGFloat {
        let labelWidth = UIScreen.main.bounds.size.width - 118.0 - 57.0
        let titleLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: labelWidth, height: 19.5))
        titleLabel.font = UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.medium)
        let appInfo: AppInfo = self.listItems[indexPath.row]
        titleLabel.text = appInfo.name.label
        let diff = Util.getLabelSize(label: titleLabel, lines: 2, isWidth: false).height - titleLabel.frame.size.height
        //print("====== diff - \(diff)")
        return diff
    }
    
    func goToFinanceFreeAppDetailView(detailInfo: LookUp) {
        let detailView = self.storyboard?.instantiateViewController(withIdentifier: "DetailView") as! DetailViewController
        detailView.detailInfo = detailInfo
        self.navigationController?.pushViewController(detailView, animated: true)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84.0 + getTitleLabelHeightDiff(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        let appInfo: AppInfo = self.listItems[indexPath.row]
        
        let number: UILabel = cell.contentView.subviews[0] as! UILabel
        number.text = "\(indexPath.row + 1)"
        let icon: UIImageView = cell.contentView.subviews[1] as! UIImageView
        icon.layer.cornerRadius = 15.0
        icon.layer.borderWidth = 1.0
        icon.layer.borderColor = UIColor(red: 193.0/255.0, green: 193.0/255.0, blue: 193.0/255.0, alpha: 1.0).cgColor
        icon.image = nil;
        NetworkHelper.networkHelper.downloadImageWithUrl(imageUrl: appInfo.image[1].label!) { (image) in
            if let downloadImage = image {
                icon.image = downloadImage;
            }
        }
        
        let downloadButtonView = cell.contentView.subviews[2]
        downloadButtonView.layer.cornerRadius = 3.0
        downloadButtonView.layer.borderWidth = 1.0
        downloadButtonView.layer.borderColor = UIColor(red: 12.0/255.0, green: 103.0/255.0, blue: 251.0/255.0, alpha: 1.0).cgColor
        
        let downloadLabel: UILabel = cell.contentView.subviews[3] as! UILabel
        downloadLabel.text = appInfo.price.label
        downloadLabel.constraints[0].constant = Util.getLabelSize(label: downloadLabel, lines: 1, isWidth: true).width
        
        let titleLabel: UILabel = cell.contentView.subviews[4] as! UILabel
        titleLabel.text = appInfo.name.label
        titleLabel.numberOfLines = 0
        
        let categoryLabel: UILabel = cell.contentView.subviews[5] as! UILabel
        categoryLabel.text = appInfo.category.attributes?.label

        
     
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (!self.isSelected) {
            self.isSelected = true
            let appInfo: AppInfo = self.listItems[indexPath.row]
            getFinanceFreeAppDetail(appId: (appInfo.id.attributes?.id)!)
        }
    }
}
