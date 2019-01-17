
import UIKit

class StudentListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if StudentsModel.studentLocations.count == 0 {
            loadStudentLocationList()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    func loadStudentLocationList() {
        ParseClient.getLocationList() { students, error in
            if let error = error {
                print("Error downloading student locations: \(error.localizedDescription)")
            }
            else{
                print("Downloaded \(students.count) student locations successfully")
                StudentsModel.studentLocations = students
                self.tableView.reloadData()
            }
        }
    }
}

extension StudentListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentsModel.studentLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell")!
        
        let student = StudentsModel.studentLocations[indexPath.row]
        
        cell.textLabel?.text = student.getFullName()
        cell.detailTextLabel?.text = student.getUrlString()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let student = StudentsModel.studentLocations[indexPath.row]
        if let url = student.mediaURL, let studentUrl = URL(string: url) {
            UIApplication.shared.open(studentUrl, options: [:], completionHandler: nil)
        }
        else {
            showUrlFailure()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
