import UIKit

class BeersViewController : UITableViewController {
    var beers : [Beer] = []
    var currentTask: NSURLSessionTask?
    
 
    override func viewDidLoad(){
        currentTask = Service.sharedService.createFetchTask{
            result in switch result {
            case .Success(let beers):
                self.beers = beers
                self.tableView.reloadData()
            case .Failure(let error):
                debugPrint(error)
            }
        }
        currentTask!.resume()
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beers.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let lot = beers[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("beerLotCell", forIndexPath: indexPath)
        as! BeersTableViewCell
        //source http://www.scriptscoop.net/t/8c0f88702eaa/display-image-from-url-in-swift-unwrapping-error.html
        let imageData = NSData(contentsOfURL: lot.image)
        let image = UIImage(data: imageData!)
        if let actualImage = image {
            cell.imageSmallView.image = actualImage
        }
        
        cell.titleLabel.text = lot.name
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let beerController = segue.destinationViewController as! BeerViewController
        let selectedRow = tableView.indexPathForSelectedRow!.row
        let selectedBeer = beers[selectedRow]
        beerController.beer = selectedBeer
    }

}