//
//  CompaniesController + UITableView.swift
//  CoreDataPracticeApp
//
//  Created by shubham sharma on 09/10/24.
//

import UIKit

extension CompaniesController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let company = companies[indexPath.row]
        let employeesController = EmployeesController()
        employeesController.company = company
        navigationController?.pushViewController(employeesController, animated: true)
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
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "No companies available..."
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return companies.count == 0 ? 150 : 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! CompanyCell

        let company = companies[indexPath.row]
        cell.company = company

        return cell
    }
}
