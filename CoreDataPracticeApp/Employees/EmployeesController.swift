//
//  EmployeesController.swift
//  CoreDataPracticeApp
//
//  Created by shubham sharma on 09/10/24.
//

import UIKit
import CoreData

//uilabel subclass for custom text drawing

class IndentedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let customRect = rect.inset(by: insets)
        super.drawText(in: customRect)
        
    }
}

class EmployeesController: UITableViewController {

    var company: Company?
    
//    var employees = [Employee]()
    let cellId = "cellID"
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company?.name
    }
    
    var allEmployees = [[Employee]]()
    var employeeTypes = [
        EmployeeType.Executive.rawValue,
        EmployeeType.SeniorManagement.rawValue,
        EmployeeType.Staff.rawValue,
        EmployeeType.Intern.rawValue
    ]
    
    private func fetchEmployees() {
        print("Trying to fetch employees...")
        //because getting relation of company employees in sets
        guard let companyEmployees = company?.employees?.allObjects as? [Employee] else { return }
        allEmployees = []
        
        employeeTypes.forEach { employeeType in
        
            allEmployees.append(
                companyEmployees.filter{ $0.type == employeeType}
            )
        }
        
//        let executives = companyEmployees.filter { employee in
//            return employee.type == EmployeeType.Executive.rawValue
//        }
//        let seniorManagement = companyEmployees.filter{ $0.type == EmployeeType.SeniorManagement.rawValue}
//        let staff = companyEmployees.filter{ $0.type == EmployeeType.Staff.rawValue}
//        
//        allEmployees = [
//        executives, seniorManagement, staff
//        ]
        print("all emloyees",allEmployees)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchEmployees()

        view.backgroundColor = .darkBlue
        
        setupPlusButtonInNavBar(selector: #selector(handleAdd))

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
    }

    @objc private func handleAdd() {
        
        let createEmployeeController = CreateEmployeeController()
        createEmployeeController.delegate = self
        createEmployeeController.company = company
        let navController = CustomeNavigationController(rootViewController: createEmployeeController)
        navController.modalPresentationStyle = .fullScreen
        
       present(navController, animated: true)
    }
    

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allEmployees.count
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentedLabel()
//        if section == 0 {
//            label.text = EmployeeType.Executive.rawValue
//        } else if section == 1{
//            label.text = EmployeeType.SeniorManagement.rawValue
//        } else {
//            label.text = EmployeeType.Staff.rawValue
//        }
//        
        label.text = employeeTypes[section]
        label.textColor = .darkBlue
        label.backgroundColor = UIColor.lightBlue
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEmployees[section].count
//        if section == 0 {
//            return shortNameEmployees.count
//        }else {
//            return longNameEmployees.count
//        }
        
//        return employees.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        

        
//        let employee = employees[indexPath.row]
        
//        let employee = indexPath.section == 0 ? shortNameEmployees[indexPath.row] : longNameEmployees[indexPath.row]
        
        let employee = allEmployees[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = employee.name
        
        if let birthday = employee.employeeInformation?.birthday {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            
            cell.textLabel?.text = "\(employee.name ?? "") : \(dateFormatter.string(from: birthday))"
        }
        
//        if let taxId = employee.employeeInformation?.taxId {
//            cell.textLabel?.text = "\(employee.name ?? "") taxId: \(taxId)"
//        }
        
        cell.backgroundColor = UIColor.tealColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        return cell
    }

}

extension EmployeesController : CreateEmployeeControllerDelegate {
    func didAddEmployee(employee: Employee) {
        
//        fetchEmployees()
//        tableView.reloadData()
        guard let employeeType = employee.type else { return }
        
        guard let section = employeeTypes.firstIndex(of: employeeType) else { return }
        let row = allEmployees[section].count
        
        let insertionIndexPath = IndexPath(row: row, section: section)
        
        allEmployees[section].append(employee)
        
        tableView.insertRows(at: [insertionIndexPath], with: .middle)
    }
}
