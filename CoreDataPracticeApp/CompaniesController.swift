//
//  ViewController.swift
//  CoreDataPracticeApp
//
//  Created by shubham sharma on 21/09/24.
//

import UIKit
//14
class CompaniesController: UITableViewController {
    
    var companies = [
        Company(name: "google", founded: Date()),
        Company(name: "Facebook", founded: Date()),
    Company(name: "Apple", founded: Date())
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        view.backgroundColor = .white

        navigationItem.title = "Companies"
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }

        tableView.backgroundColor = UIColor.darkBlue
//        tableView.separatorStyle = .none
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddCompany))
        
//        setupNavigationStyle()

    }

    @objc func handleAddCompany() {
        
        let createCompanyController = CreateCompanyController()

        let navController = CustomeNavigationController(rootViewController: createCompanyController)
        navController.modalPresentationStyle = .fullScreen
        createCompanyController.delegate = self
      
        present(navController, animated: true)

    }
    

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .lightBlue
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)

        let company = companies[indexPath.row]
        cell.backgroundColor = .tealColor
        cell.textLabel?.text = company.name
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return cell
    }
    
    

    
}

extension CompaniesController: CreateCompanyControllerDelegate {
    func didAddCompany(company: Company) {
        companies.append(company)
        let newIndexPath = IndexPath(row: companies.count-1 , section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
}
