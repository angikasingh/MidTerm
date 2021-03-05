//
//  NewsTableViewController.swift
//  GetNewsTitle
//
//  Created by Angika Singh on 2/25/21.
//

import UIKit
import Alamofire
import SwiftSpinner
import SwiftyJSON

class NewsTableViewController:
    UITableViewController {
    var newsarr: [String] = [String]()
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newsarr.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = newsarr[indexPath.row]

        return cell
    }
    
    func getURL() -> String {
        var url = apiUrl
        url.append("&apiKey=")
        url.append(apiKey)
        return url
    }

    func getData() {
        let url = getURL()
        SwiftSpinner.show("Fetching News")
        AF.request(url).responseJSON { response in
            SwiftSpinner.hide()
            if response.error == nil {
                let news: JSON = JSON(response.data!)
                for (_, article) in news["articles"] {
                    self.newsarr.append(article["title"].stringValue)
                }
            } else {
                print("Error")
                print(response.error!)
            }
            
            self.table.reloadData()
        }
    }
}
