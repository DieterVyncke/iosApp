import UIKit
import CoreData

class FavoriteBeersController : UITableViewController {
    
    var beers = [NSManagedObject]()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let fetchRequest = NSFetchRequest(entityName: "Beer")

    override func viewDidLoad() {
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        read()
        self.tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beers.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("beerFavoriteCell", forIndexPath: indexPath) as! BeerFavoriteTableViewCell
        let lot = beers[indexPath.row]
        
        cell.titleLabel.text = lot.valueForKey("name") as? String
        cell.ratingLabel.text = String(lot.valueForKey("rating") as! Int)
        cell.tastedTotal.text = String(lot.valueForKey("tastedTotal") as! Int)
        
        cell.incrementTastedTotalButton.tag = indexPath.row;
        cell.incrementTastedTotalButton.addTarget(self, action: "incrementTastedTotalNumber:", forControlEvents: .TouchUpInside)
        return cell
    }
    
    @IBAction func incrementTastedTotalNumber(sender: UIButton) {
        let selectedBeer = self.beers[sender.tag].valueForKey("name") as? String
        update(selectedBeer!)
        self.tableView.reloadData()
    }
    
    func update(selectedBeer: String)
    {
        let managedContext = appDelegate.managedObjectContext
        
        let beerRequest = NSFetchRequest(entityName: "Beer")
        beerRequest.predicate = NSPredicate(format: "name = %@", selectedBeer)
        do{
            if let beerResults = try appDelegate.managedObjectContext.executeFetchRequest(beerRequest) as? [NSManagedObject]
            {
                if(beerResults.count != 0){
                    let selectedBeer = beerResults[0]
                    let updatedTotal : Int = (selectedBeer.valueForKey("tastedTotal") as! Int) + 1
                    selectedBeer.setValue(updatedTotal, forKey: "tastedTotal")
                    try managedContext.save()
                }
            }
            
        }
        catch {
            print(error)
        }

    }

    func read()
    {
        let managedContext = appDelegate.managedObjectContext
        
        do
        {
            let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            //reinitialize beers[]
            beers = [NSManagedObject]()
            
            for beer in fetchedResults!{
                if(beer.valueForKey("name") != nil){
                   beers.append(beer)
                }
            }
        }
        catch
        {
            print("error")
        }

    }
}
