//
//  PlayersTableViewController.swift
//  SportsPlayersApp
//
//  Created by Maha saad on 23/05/1443 AH.
//

import UIKit

class PlayersTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let saveContext = (UIApplication.shared.delegate as! AppDelegate).saveContext
        
        var sport:Sport!

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sport.players?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt  indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell()
            
            if let player = sport.players?[indexPath.row] as? Player {
                cell.textLabel?.text = "\(player.name ?? "") - \(player.age ?? "") - \(player.height ?? "")"
            }
            
            
            return cell
        }
    
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let player = sport.players?[indexPath.row] as! Player
        editPlayer(player)
       
        }
    
 
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            let player = sport.players?[indexPath.row] as! Player
            sport.removeFromPlayers(player)
            saveContext()
            tableView.reloadData()
        }
    

    @IBAction func addPlayer(_ sender: UIBarButtonItem) {
        
        addPlayerAlert()
        
    }
    func addPlayerAlert(){
            let alert = UIAlertController(title: "Add Player", message: "Enter Player Details:", preferredStyle: .alert)
            
            alert.addTextField {
                (textField) in
                textField.placeholder = "Player Name"
            }
            
            alert.addTextField {
                (textField) in
                textField.placeholder = "Player Age"
            }
            
            alert.addTextField {
                (textField) in
                textField.placeholder = "Player Height"
            }
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let playerName = alert?.textFields![0]
                let playerAge = alert?.textFields![1]
                let playerHeight = alert?.textFields![2]
                let player = Player(context: self.context)
                player.name = playerName?.text
                player.age = playerAge?.text
                player.height = playerHeight?.text
                player.sport = self.sport
                self.saveContext()
                self.tableView.reloadData()
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    
    func editPlayer(_ player:Player){
            let alert = UIAlertController(title: "Edit Player", message: nil, preferredStyle: .alert)
            
            alert.addTextField {
                (textField) in
                textField.text = player.name
            }
            
            alert.addTextField {
                (textField) in
                textField.text = player.age
            }
            
            alert.addTextField {
                (textField) in
                textField.text = player.height
            }
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let playerName = alert?.textFields![0]
                let playerAge = alert?.textFields![1]
                let playerHeight = alert?.textFields![2]
                player.name = playerName?.text
                player.age = playerAge?.text
                player.height = playerHeight?.text
                player.sport = self.sport
                self.saveContext()
                self.tableView.reloadData()
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    

}
