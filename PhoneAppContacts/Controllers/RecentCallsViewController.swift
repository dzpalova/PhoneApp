import UIKit

class RecentCallsTableController: UITableViewController {
    var recentCallStore = SceneDelegate.recentCallStore

    var indexOfRecentCallsToOpen: IndexPath!
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var clearAllButton: UIBarButtonItem!
    
    @IBAction func changeSegmentedControlValue(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    @IBAction func clearAllPressed(_ sender: UIBarButtonItem) {
        if !isEditing {
            return
        }

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
        let clearAllAction = UIAlertAction(title: "Clear All", style: .destructive) { _ in
            self.recentCallStore.deleteAll()
            self.tableView.reloadData()
        }
        alertController.addAction(clearAllAction)
                
        let cancelAction = UIAlertAction(title: "Don't clear", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
                
        present(alertController, animated: true, completion: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        title = "Recents"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recentCallStore = RecentsStore()
        tableView.reloadData()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        navigationItem.leftBarButtonItem?.title = editing ? "Clear" : ""
    }
    
    private func displayNoItemsLabel() {
        tableView.separatorStyle = .none
        let noItemsLabel = UILabel(frame: tableView.frame)
        noItemsLabel.text = "No Items"
        noItemsLabel.textAlignment = .center
        tableView.backgroundView = noItemsLabel
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if recentCallStore.callsCount() == 0 {
            displayNoItemsLabel()
        }
        return segmentedControl.selectedSegmentIndex == 0 ?
            recentCallStore.callsCount() : recentCallStore.missedCallsCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "callCell", for: indexPath) as! RecentCallCell
        let calls = segmentedControl.selectedSegmentIndex == 0 ?
            recentCallStore.getCalls(at: indexPath) : recentCallStore.getMissedCalls(at: indexPath)
        cell.setCell(with: calls)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if segmentedControl.selectedSegmentIndex == 0 {
                recentCallStore.removeCall(at: indexPath)
            } else {
                recentCallStore.removeMissedCall(at: indexPath)
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        indexOfRecentCallsToOpen = indexPath
        performSegue(withIdentifier: "showContactFromRecents", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexOfRecentCallsToOpen = indexPath
        performSegue(withIdentifier: "callFromRecents", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let contact = recentCallStore.getContact(idx: indexOfRecentCallsToOpen)
        let calls = recentCallStore.getCalls(at: indexOfRecentCallsToOpen)
        
        switch segue.identifier {
        case "showContactFromRecents":
            let contactController = segue.destination as! ContactController
            contactController.contact = contact
            contactController.recentCalls = calls
        case "callFromRecents":
            let convController = segue.destination as! ConversationViewController
            convController.contactObject = contact
            convController.number = calls.first!.number
        default:
            break
        }
    }
}
