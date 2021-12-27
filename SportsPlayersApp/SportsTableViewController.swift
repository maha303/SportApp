//
//  SportsTableViewController.swift
//  SportsPlayersApp
//
//  Created by Maha saad on 23/05/1443 AH.
//

import UIKit
import CoreData

class SportsTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
       let saveContext = (UIApplication.shared.delegate as! AppDelegate).saveContext
    let imageVC = UIImagePickerController()
    var sports : [Sport] = []
    
    var selectedSport : Sport!
    
    func fetchSports() {
            do{
                sports = try context.fetch(Sport.fetchRequest())
            }catch{
                print(error)
            }
            tableView.reloadData()
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchSports()

       
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sports.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sportsCell", for: indexPath) as! SportViewCell
        cell.sportNameLabel.text = sports[indexPath.row].name
        if let imageData = sports[indexPath.row].image {
                    let image = UIImage(data: imageData)!
                    cell.sportImage.image = image
                }
                
                cell.cellDelegate = self
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showplayers", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let playerVC = segue.destination as! PlayersTableViewController
            let indexPath = sender as! IndexPath
            let sport = sports[indexPath.row]
            playerVC.title = sport.name?.capitalized
            playerVC.sport = sport
        }
    
    
    @IBAction func addSport(_ sender: UIBarButtonItem) {
        addSportAlert()
        
    }
    func addSportAlert(){
            let alert = UIAlertController(title: "Add Sport", message: "Enter Sport Name:", preferredStyle: .alert)
            
            alert.addTextField {
                (textField) in
                textField.placeholder = "Sport Name eg.. BasketBall"
            }
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0]
                let item = Sport(context: self.context)
                item.name = textField?.text!
                self.saveContext()
                self.fetchSports()
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
            editSportAlert(sports[indexPath.row])
        }
    func editSportAlert(_ sport:Sport){
            let alert = UIAlertController(title: "Add Sport", message: "Enter Sport Name:", preferredStyle: .alert)
            
            alert.addTextField {
                (textField) in
                textField.text = sport.name
            }
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let nameField = alert?.textFields![0]
                sport.name = nameField?.text!
                self.saveContext()
                self.fetchSports()
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            let item = sports[indexPath.row]
            context.delete(item)
            saveContext()
            sports.remove(at: indexPath.row)
            tableView.reloadData()
        }
}
extension SportsTableViewController : CellDelegate {
    func changeImage(_ cell: SportViewCell) {
        let selectedSportI = tableView.indexPath(for: cell)?.row ?? 0
        selectedSport = sports[selectedSportI]
        imageVC.delegate = self
        present(imageVC, animated: true, completion: nil)
        
    }
}

extension SportsTableViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            selectedSport.image = image.pngData()
            saveContext()
        }
        self.fetchSports()
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
