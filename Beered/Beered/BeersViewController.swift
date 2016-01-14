import UIKit

class BeersViewController : UITableViewController {
    var beers : [Beer] = []
    var currentTask: NSURLSessionTask?
    
    //uitwerking van de searchbar adv volgende voorbeeld: http://www.raywenderlich.com/113772/uisearchcontroller-tutorial 
    let searchController = UISearchController(searchResultsController: nil)
    var searchResults: [Beer] = []
    
 
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
        
        //initialiseren van de searchcontroller
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        //enkel zicthbaar op deze view
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Als er op data w gezocht enkel deze weergeven
        if searchController.active && searchController.searchBar.text != "" {
            return searchResults.count
        }
        return beers.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("beerLotCell", forIndexPath: indexPath) as! BeersTableViewCell
        let lot: Beer
        if searchController.active && searchController.searchBar.text != ""{
            lot = searchResults[indexPath.row]
        }else{
            lot = beers[indexPath.row]
        }
        
        //source http://www.scriptscoop.net/t/8c0f88702eaa/display-image-from-url-in-swift-unwrapping-error.html
        let imageData = NSData(contentsOfURL: lot.image)
        if imageData != nil{
            let image = UIImage(data: imageData!)
            if let actualImage = image {
                cell.imageSmallView.image = actualImage
            }
        }
        
        cell.titleLabel.text = lot.name
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let beerController = segue.destinationViewController as! BeerViewController
        let selectedRow = tableView.indexPathForSelectedRow!.row
        let selectedBeer: Beer
        //Het juiste beer meegeven.
        if searchController.active && searchController.searchBar.text != "" {
            selectedBeer = searchResults[selectedRow]
        }else{
            selectedBeer = beers[selectedRow]
        }
        beerController.beer = selectedBeer
    }
    
    //search bar
    func filterContentForSearchText(searchText: String){
        self.searchResults = self.beers.filter{ aBeer in
            //checkt of de ingegeven naam voorkomt in de beerslist (Bool)
            return aBeer.name.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
    


}

extension BeersViewController: UISearchResultsUpdating {
    //enige methode die moet geimplementeerd worden om te voldoen aan UISearchResultsUpdating protocol
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}