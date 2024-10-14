//
//  CoreDataManager.swift
//  CoreDataPracticeApp
//
//  Created by shubham sharma on 08/10/24.
//

import CoreData

struct CoreDataManager {
    
    // will live forever as long as your application is still alive, it's properties will too
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        // Initialization of core data stack
        let container = NSPersistentContainer(name: "PracticeAppDataModel")
        container.loadPersistentStores { storeDescription, error in
            if let err = error {
                fatalError("Loading of store failed: \(err)")
            }
        }
        return container
        
    }()
    
    func fetchCompanies() -> [Company] {
    
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        
        do {
            let companies = try context.fetch(fetchRequest)
            return companies
         
        }catch let error {
            print("Failed to fetch companies: ",error)
            return []
        }
    }
    
    func createEmployee(employeeName: String, employeeType: String, birthday: Date, company: Company) -> (Employee?, Error?){
        let context = persistentContainer.viewContext
        
        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee
        
        employee.company = company
        employee.type = employeeType
        employee.setValue(employeeName, forKey: "name")
        
        let employeeInformation = NSEntityDescription.insertNewObject(forEntityName: "EmployeeInformation", into: context) as! EmployeeInformation
        
        employeeInformation.taxId = "456"
        employeeInformation.birthday = birthday
//        employeeInformation.setValue("123", forKey: "taxId")
        
        employee.employeeInformation = employeeInformation
        
        do {
            try context.save()
            return (employee, nil)
            
        } catch let err {
            
            print("Failed to create employee:", err)
            return (nil, err)
        }
        
    }
    
}
