//
//  SecondViewController.swift
//  Treds
//
//  Created by Philip on 3/22/19.
//  Copyright © 2019 Philip. All rights reserved.
//

import UIKit

class MyLogVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
}

extension MyLogVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Run.getAllRuns()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RunLogCell") as? RunLogCell {
            guard let run = Run.getAllRuns()?[indexPath.row] else {
                return RunLogCell()
            }
            
            cell.configure(run: run)
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

