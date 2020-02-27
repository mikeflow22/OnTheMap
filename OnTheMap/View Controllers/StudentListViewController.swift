//
//  StudentListViewController.swift
//  OnTheMap
//
//  Created by Michael Flowers on 2/26/20.
//  Copyright © 2020 Michael Flowers. All rights reserved.
//

import UIKit

class StudentListViewController: UIViewController {
    
    var students: [Student]? {
        didSet {
            guard let students = students else {
                print("Error in file: \(#file), in the body of the function: \(#function) on line: \(#line)\n")
                return
            }
            self.tableView.reloadData()
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        get100Students()
    }
    
    func get100Students(){
        NetworkController.shared.orderStudentsInList { (error) in
            if let error = error {
                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
                return
            }
            self.students = NetworkController.shared.orderedStudents
        }
        
//        NetworkController.shared.getStudentsWithALimit(studentLimit: 100) { (error) in
//            if let error = error {
//                print("Error in file: \(#file) in the body of the function: \(#function)\n on line: \(#line)\n Readable Error: \(error.localizedDescription)\n Technical Error: \(error)\n")
//                return
//            } else {
//                self.students =  NetworkController.shared.students
//            }
//        }
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        NetworkController.shared.logout(completion: self.handleLogoutResponse(success:error:))
    }
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        //clear student array
        self.students?.removeAll()
        
        //network call to retrieve students
        get100Students()
    }
    
    @IBAction func addStudentLocation(_ sender: UIBarButtonItem) {
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension StudentListViewController: UITableViewDelegate,  UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath)
        
        let student = students?[indexPath.row]
        cell.textLabel?.text = student?.fullName
//        cell.detailTextLabel?.text = student?.mediaURL
        cell.detailTextLabel?.text = student?.createdAt
        
        cell.imageView?.image = UIImage(named: "icon_pin")
        
        return  cell
    }
    
    
}
