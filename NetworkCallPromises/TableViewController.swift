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
import PromiseKit

class TableViewController:
    UITableViewController {
    var arr: [CovidResponse] = [CovidResponse]()
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arr.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        cell.lblState.text = arr[indexPath.row].state
        cell.lblTotal.text = "\(arr[indexPath.row].total)"
        cell.lblPositive.text = "\(arr[indexPath.row].positive)"
        return cell
    }
    
    func getURL() -> String {
        return apiUrl
    }

    func getData() {
        let url = getURL()
        SwiftSpinner.show("Fetching Covid-19 results")
        getValue(url: url)
            .done { (results) in
                self.arr = results
                self.table.reloadData()
            }
            .catch { (error) in
                print("error")
                print(error)
            }
    }
    
    func getValue(url : String) -> Promise<[CovidResponse]> {
        return Promise<[CovidResponse]> { seal -> Void in
            AF.request(url).responseJSON { response in
                SwiftSpinner.hide()
                if response.error == nil {
                    guard let data = response.data else {
                        return seal.fulfill([CovidResponse]())
                    }
                    guard let results = JSON(data).array else {
                        return seal.fulfill([CovidResponse]())
                    }
                    
                    var arr: [CovidResponse] = [CovidResponse]()
                    
                    for result in results {
                        let covidResponse : CovidResponse = CovidResponse()
                        covidResponse.state = result["state"].stringValue
                        covidResponse.total = result["total"].intValue
                        covidResponse.positive = result["positive"].intValue
                        arr.append(covidResponse)
                    }
                    seal.fulfill(arr)
                } else {
                    seal.reject(response.error!)
                }
                
                self.table.reloadData()
            }
        }
    }
}
