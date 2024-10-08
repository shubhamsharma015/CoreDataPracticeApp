//
//  ViewController.swift
//  CoreDataPracticeApp
//
//  Created by shubham sharma on 21/09/24.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController {
   
    var companies = [Company]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.companies = CoreDataManager.shared.fetchCompanies()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
        
        view.backgroundColor = .white

        navigationItem.title = "Companies"
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }

        tableView.backgroundColor = UIColor.darkBlue
//        tableView.separatorStyle = .none
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
        
        tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellId")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddCompany))
        
//        setupNavigationStyle()

    }

    @objc private func handleReset() {
        print("Attempting to delete all core data objects")
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        do {
            try context.execute(batchDeleteRequest)
            // for the best animation 
            var indexPathsToRemove = [IndexPath]()
            
            for (index, _) in companies.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathsToRemove.append(indexPath)
            }
            companies.removeAll()
            tableView.deleteRows(at: indexPathsToRemove, with: .left)
            
//            companies.removeAll()
//            tableView.reloadData()
            
            
        } catch let delErr {
            print("Failed to delete objects from Core Data:", delErr)
        }
        
    }
    
    @objc func handleAddCompany() {
        
        let createCompanyController = CreateCompanyController()

        let navController = CustomeNavigationController(rootViewController: createCompanyController)
        navController.modalPresentationStyle = .fullScreen
        createCompanyController.delegate = self
      
        present(navController, animated: true)

    }
    


   
}
//MARK: CreateCompanyControllerDelegate METHODS

extension CompaniesController: CreateCompanyControllerDelegate {
    func didEditCompany(company: Company) {
        guard let row = companies.firstIndex(of: company) else { return }
        let reloadIndexPath = IndexPath(row: row, section: 0)
        
        tableView.reloadRows(at: [reloadIndexPath], with: .fade)
        
    }
    
    func didAddCompany(company: Company) {
        companies.append(company)
        let newIndexPath = IndexPath(row: companies.count-1 , section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
}
