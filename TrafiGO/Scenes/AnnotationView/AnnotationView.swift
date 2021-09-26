//
//  AnnotationView.swift
//  TrafiGO
//
//  Created by Darek on 16/09/2021.
//

import UIKit

class AnnotationView: UIView{
    // MARK: - IBOulets
    @IBOutlet weak var titleLAbel: UILabel!
    @IBOutlet weak var annotationTable: UITableView!
    @IBOutlet weak var loadingBusInfoIndicator: UIActivityIndicatorView!
    
    // MARK: - Variables
    var timeTable: [[String]] = []
    
    override func awakeFromNib() {
       super.awakeFromNib()
        annotationTable.delegate = self
        annotationTable.dataSource = self
        annotationTable.allowsSelection = true
    }
}


extension AnnotationView: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("AnnotationTableViewCell", owner: self, options: nil)?.first as! AnnotationTableViewCell

        if timeTable[indexPath.row].count == 1{
            cell.busDestinationLabel.text = "Brak zaplanowanych przyjazdów"
        } else {
            cell.busNumberLabel.text = timeTable[indexPath.row][0]
            cell.busDestinationLabel.text = timeTable[indexPath.row][1]
            cell.busTimeLabel.text = timeTable[indexPath.row][2]
        }
        return cell
    }
}



