import Foundation

class Service {
    enum Error: ErrorType {
        case MissingJsonProperty(name: String)
        case NetworkError(message: String?)
        case UnexpectedStatusCode(code: Int)
        case MissingData
        case InvalidJsonData
    }
    
    static let sharedService = Service()
    
    private let url: NSURL
    private let session: NSURLSession
    var beers = [Beer]()
    
    init() {
        let propertiesPath = NSBundle.mainBundle().pathForResource("Properties", ofType: "plist")!
        let properties = NSDictionary(contentsOfFile: propertiesPath)!
        let baseUrl = properties["baseUrl"] as! String
        url = NSURL(string: baseUrl)!
        session = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
    }
    
    func createFetchTask(completionHandler: (Result<[Beer]>) -> Void) -> NSURLSessionTask {
        return session.dataTaskWithURL(url) {
            data, response, error in

            
            
            //schaduwvar
            let completionHandler: Result<[Beer]> -> Void = {
                result in
                //uitvoeren op een andere thread
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler(result)
                }
            }
            
            //falen indien geen netwerk
            guard let response = response as? NSHTTPURLResponse else {
                //throw error
                completionHandler(.Failure(.NetworkError(message: error?.description)))
                return
            }
            
            guard response.statusCode == 200 else {
                //throw error
                completionHandler(.Failure(.UnexpectedStatusCode(code: response.statusCode)))
                return
            }
            
            guard let data =  data else {
                //throw error
                completionHandler(.Failure(.MissingData))
                return
            }
            
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! [Dictionary<String,AnyObject>]
                for beer in json {
                        let id = beer["beer_id"] as! Int
                        let name = beer["name"] as! String
                        let type = beer["type"] as! String
                        let imageFromJson = beer["image_url"] as! String
                            let imageUrl = NSURL(string: imageFromJson)!
                    
                        let country = beer["country"] as! String
                        let abv = beer["abv"] as! String
                        let brewer = beer["brewer"] as! String
                        let category = beer["category"] as! String
                        let nBeer = Beer(name: name, image: imageUrl, category: category, abv: abv, type: type, brewer: brewer, country: country, beer_id: id)
                        //print(nBeer)
                        self.beers.append(nBeer)
                }
                
                let filteredBeers = self.beers.filter({
                        $0.country == "Belgium"
                })
                
                //deze handler beslist over de results
                completionHandler(.Success(filteredBeers))
                
                //als error NsError is, doe dit
            } catch _ as NSError{
                //trhow error
                completionHandler(.Failure(.InvalidJsonData))
            } catch let error as Error {
                //throw error
                completionHandler(.Failure(error))
            }
        }


            
    }
}

