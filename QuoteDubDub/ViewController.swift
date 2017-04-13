//
//  ViewController.swift
//  QuoteDubDub
//
//  Created by Mitchell Sweet on 4/4/17.
//  Copyright © 2017 Mitchell Sweet. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var handle: FIRAuthStateDidChangeListenerHandle?
    var ref: FIRDatabaseReference!
    
    let initRed = 58
    let initGreen = 44
    let initBlue = 105
    
    @IBOutlet var table:UITableView!
    
    var quotes: [String: String] = [:] {
        didSet {
            quotes_keys = Array(quotes.keys)
        }
    }
    var quotes_keys: [String] = []
    
    @IBOutlet weak var emailLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        FirebaseSetup()
        ViewSetup()
        
        
    }
    
    
    func FirebaseSetup() {
        
        FIRDatabase.database().persistenceEnabled = true
        
        ref = FIRDatabase.database().reference()
        
        // Auth stuff
        handle = FIRAuth.auth()?.addStateDidChangeListener() { auth, user in
            if user == nil {
                self.navigationController?.performSegue(withIdentifier: "signin", sender: self)
            } else {
                self.setupData(withUser: user!)
            }
        }
        
    }
    
    func setupData(withUser user: FIRUser) {
        ref.child("quotes").observe(.value, with: { snapshot in
            self.quotes = snapshot.value as? [String: String] ?? [:]
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        })
        

    }
    

    @IBAction func didTapSignout(_ sender: Any) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let error {
            print("Error on signout: \(error.localizedDescription)")
        }
    }
    
    @IBAction func didTapAdd(_ sender: Any) {
        let alert = UIAlertController(title: "Add Data", message: "Enter your quote: ", preferredStyle: .alert)
        
        alert.addTextField() { textfield in
        }
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { [weak alert] _ in
            guard let textField = alert?.textFields?[0] else { return }
            guard let text = textField.text else { return }
            guard !text.isEmpty else { return }
            //guard let user = FIRAuth.auth()?.currentUser?.email else { return }
            //guard let userCode = FIRAuth.auth()?.currentUser else { return }
            
            // Save text
            self.ref.child("quotes").childByAutoId().setValue(text)
        })
        
        self.present(alert, animated: true)
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes_keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let key = quotes_keys[indexPath.row]
        let data = quotes[key]
        
        cell.backgroundColor = UIColor(red: CGFloat(initRed - (indexPath.row * 20))/255 , green: CGFloat(initGreen - (indexPath.row * 20))/255, blue: CGFloat(initBlue - (indexPath.row * 20))/255, alpha: 1.0)
        
        cell.textLabel?.text = data ?? ""
        cell.textLabel?.textColor = UIColor.white
        //cell.detailTextLabel?.text = key
        
        return cell
}
    

    
    
    func ViewSetup() {
        
        self.title = "WWDC Quotes"
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2201197147, green: 0.1726153195, blue: 0.4058898091, alpha: 1)
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        
        
    }


}

