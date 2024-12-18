//
//  TableViewController.swift
//  swift_MySQL
//
//  Created by BUMPIE on 12/18/24.
//

import UIKit

class TableViewController: UITableViewController {

    @IBOutlet var tvAddress: UITableView!
    
    
    var dataArray : [Address] = []
    var imageArray : [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataInit()
        imageInit()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    func dataInit(){
        dataArray.append(
            Address(
                name: "james",
                phoneNumber: "1111",
                address: "서울시",
                relation: "친구",
                photo: UIImage(named: "lamp_on.png")!
            )
        )
    }
    
    func imageInit(){
        for address in dataArray{
            imageArray.append(address.photo)
        }
    }
    
    
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath) as! TableViewCell
        
        cell.lblName.text = dataArray[indexPath.row].name
        cell.lblPhoneNum.text = dataArray[indexPath.row].phoneNumber
        
        let tempImage = dataArray[indexPath.row].photo
        let resizedImage = UIGraphicsImageRenderer(size: CGSize(width: 60, height: 60)).image { _ in
            tempImage.draw(in: CGRect(origin: .zero, size: CGSize(width: 60, height: 60)))
        }
        cell.cellImageView.image = resizedImage
        
        
        
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            dataArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let itemToMove = dataArray[fromIndexPath.row]
        dataArray.remove(at: fromIndexPath.row)
        dataArray.insert(itemToMove, at: to.row)
    }
    

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        
        
        
        return true
    }
    
    */
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sgUpdate"{
            let cell = sender as! UITableViewCell
            let indexPath = tvAddress.indexPath(for: cell)
            let updateDeleteView = segue.destination as! UpdateDeleteViewController
            updateDeleteView.curAddress = dataArray[indexPath!.row]

        }
    }


}
