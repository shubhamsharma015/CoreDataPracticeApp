//
//  ViewController.swift
//  CoreDataPracticeApp
//
//  Created by shubham sharma on 21/09/24.
//

import UIKit
import CoreData
//14
class CompaniesController: UITableViewController {
   
    var companies = [Company]()
    
//    var companies = [
//        Company(name: "google", founded: Date()),
//        Company(name: "Facebook", founded: Date()),
//    Company(name: "Apple", founded: Date())
//    ]

    private func fetchCompanies() {
        
//        let persistentContainer = NSPersistentContainer(name: "PracticeAppDataModel")
//        persistentContainer.loadPersistentStores { storeDescription, error in
//            if let err = error {
//                fatalError("Loading of store failed: \(err)")
//            }
//        }
//        
//        let context = persistentContainer.viewContext
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        
        do {
            let companies = try context.fetch(fetchRequest)
            companies.forEach { company in
                print(company.name ?? "")
            }
            self.companies = companies
            self.tableView.reloadData()
        }catch let error {
            print("Failed to fetch companies: ",error)
        }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        fetchCompanies()
        
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
    

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self](_, _, completionHandler) in
            guard let strontSelf = self else { return }
            let company = strontSelf.companies[indexPath.row]
            
            //remove from tableview
            strontSelf.companies.remove(at: indexPath.row)
            strontSelf.tableView.deleteRows(at: [indexPath], with: .top)
            
            //delete from core data
            let context = CoreDataManager.shared.persistentContainer.viewContext
            context.delete(company)
            
            do {
                try context.save()
            } catch let saveErr {
                print("Failed to delete company:", saveErr)
            }
            
            completionHandler(true)
        }
        deleteAction.backgroundColor = .lightRed
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self](_, _, completionHandler) in
            
            guard let strontSelf = self else { return }
            strontSelf.editHandlerFunction(forRowAt: indexPath)
            completionHandler(true)
        }
        editAction.backgroundColor = .darkBlue
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        
        swipeActions.performsFirstActionWithFullSwipe = false
        return swipeActions
    }
    
    private func editHandlerFunction(forRowAt indexPath: IndexPath) {
        print("Editing company...")
        
        let editCompanyController = CreateCompanyController()
        editCompanyController.company = companies[indexPath.row]
        
        let navController = CustomeNavigationController(rootViewController: editCompanyController)
        navController.modalPresentationStyle = .fullScreen
        editCompanyController.delegate = self
      
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
