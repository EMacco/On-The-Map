//
//  LocationListTableViewController.swift
//  On the Map
//
//  Created by Emmanuel Okwara on 10/01/2020.
//  Copyright © 2020 Emmanuel Okwara. All rights reserved.
//

import UIKit
import ProgressHUD

class LocationListTableViewController: UITableViewController {

    let reusableIdentifier = "StudentLocationTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func reloadBtnClicked(_ sender: UIBarButtonItem) {
        ProgressHUD.show("Refreshing...", interaction: false)
        fetchStudentsLocation()
    }
    
    func fetchStudentsLocation() {
        NetworkClient.fetchStudentsLocation(limit: 100, completion: handleStudentsLocationResponse(success:error:))
    }
    
    func handleStudentsLocationResponse(success: Bool, error: Error?) {
        if success {
            ProgressHUD.dismiss()
            tableView.reloadData()
        } else {
            (error?.localizedDescription ?? "").showError()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocationManager.shared.getAllStudents().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) as! StudentLocationTableViewCell

        let student = StudentLocationManager.shared.getAllStudents()[indexPath.row]
        cell.studentNameLbl.text = student.firstName + " " + student.lastName
        cell.studentLocationNameLbl.text = student.mapString
        cell.locationTimeLbl.text = convertTime(dateTime: student.updatedAt)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let toOpen = StudentLocationManager.shared.getAllStudents()[indexPath.row].mediaURL
        UIApplication.shared.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
    }
    
    func convertTime(dateTime: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "MMM d YYYY h:mm a"
        
        if let date = dateFormatter.date(from: dateTime) {
            return newDateFormatter.string(from: date)
        }
        
        return ""
    }

}
