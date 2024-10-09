//
//  EmployeesController.swift
//  CoreDataPracticeApp
//
//  Created by shubham sharma on 09/10/24.
//

import UIKit
import CoreData

class EmployeesController: UITableViewController {

    var company: Company?
    
    var employees = [Employee]()
    let cellId = "cellID"
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company?.name
    }
    
    private func fetchEmployees() {
        print("Trying to fetch employees...")
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let request = NSFetchRequest<Employee>(entityName: "Employee")
        do {
           let employee = try context.fetch(request)
            self.employees = employee
            employee.forEach{print("employee name: ", $0.name ?? "")}
        }catch let err {
            print("failed to fetch employees: ",err)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchEmployees()

        view.backgroundColor = .darkBlue
        
        setupPlusButtonInNavBar(selector: #selector(handleAdd))

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
    }

    @objc private func handleAdd() {
        
        let createEmployeeController = CreateEmployeeController()
        createEmployeeController.delegate = self
        let navController = CustomeNavigationController(rootViewController: createEmployeeController)
        navController.modalPresentationStyle = .fullScreen
        
       present(navController, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let employee = employees[indexPath.row]
        
        cell.textLabel?.text = employee.name
        cell.backgroundColor = UIColor.tealColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        return cell
    }

}

extension EmployeesController : CreateEmployeeControllerDelegate {
    func didAddEmployee(employee: Employee) {
        employees.append(employee)
        tableView.reloadData()
    }
}
