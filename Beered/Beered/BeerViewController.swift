import UIKit
import CoreData

class BeerViewController : UITableViewController, FloatRatingViewDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var abvLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var brewerLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    @IBOutlet weak var floatRatingView: FloatRatingView!
    
    var beer : Beer!
    
    override func viewDidLoad() {
        nameLabel.text = "\(beer.name)"
        categoryLabel.text = "\(beer.category)"
        abvLabel.text = "\(beer.abv)"
        typeLabel.text = "\(beer.type)"
        brewerLabel.text = "\(beer.brewer)"
        countryLabel.text = "\(beer.country)"
        
        let imageData = NSData(contentsOfURL: beer.image)
        if imageData != nil{
            let image = UIImage(data: imageData!)
            imageView.image = image
        }
        
        self.floatRatingView.delegate = self
        
        //clear_data()
    }
    
    @IBAction func tasted() {
        save(beer)
    }
    
    
    func save(beer:Beer)
    {
        let appDelegate: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let managedContext: NSManagedObjectContext = appDelegate.managedObjectContext
        let entityDescription = NSEntityDescription.entityForName("Beer", inManagedObjectContext: managedContext)
        let newEntity = NSManagedObject(entity: entityDescription!,
            insertIntoManagedObjectContext:managedContext)
        
        
        //source: http://stackoverflow.com/questions/26345189/how-do-you-update-a-coredata-entry-that-has-already-been-saved-in-swift
        //basis waarop verder is gebouwd.
        let beerRequest = NSFetchRequest(entityName: "Beer")
        beerRequest.predicate = NSPredicate(format: "name = %@", beer.name)
        do{
            if let beerResults = try appDelegate.managedObjectContext.executeFetchRequest(beerRequest) as? [NSManagedObject]
            {
                if(beerResults.count != 0){
                    let selectedBeer = beerResults[0]
                    let updatedTotal : Int = (selectedBeer.valueForKey("tastedTotal") as! Int) + 1
                    selectedBeer.setValue(updatedTotal, forKey: "tastedTotal")
                    selectedBeer.setValue(self.floatRatingView.rating, forKey: "rating")
                    try managedContext.save()
                }else{
                    newEntity.setValue(beer.name, forKey: "name")
                    newEntity.setValue(beer.category, forKey: "category")
                    newEntity.setValue(beer.abv, forKey: "abv")
                    newEntity.setValue(beer.type, forKey: "type")
                    newEntity.setValue(beer.brewer, forKey: "brewer")
                    newEntity.setValue(beer.country, forKey: "country")
                    newEntity.setValue(1, forKey: "tastedTotal")
                    newEntity.setValue(self.floatRatingView.rating, forKey: "rating")
                    
                    print("saved beer to favorite list")
                    try managedContext.save()
                }
                
                //toon wanneer bier gesaved w.
                let alert = UIAlertController(title: "SAVED", message: "Beer saved to Favorites", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        }
        catch {
            print(error)
        }
    }
    
    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float){
        print(self.floatRatingView.rating)
    }
    
 
    //clear data for testing
    func clear_data()
    {
        do
        {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            let fetchRequest = NSFetchRequest(entityName: "Beer")
            
            let fetchedResults = try managedContext.executeFetchRequest(fetchRequest)
            
            
            for (var i=0; i < fetchedResults.count; i++)
            {
                let value = fetchedResults[i]
                managedContext.deleteObject(value as! NSManagedObject)
                try managedContext.save()
            }
            
        }
        catch
        {
            print("error")
        }
        
    }


}