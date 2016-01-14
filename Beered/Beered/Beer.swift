import Foundation

class Beer {
    let name: String
    let beer_id: Int
    let type: String
    let image: NSURL
    let country: String
    let abv: String
    let brewer: String
    let category: String
    
    init(name: String, image: NSURL, category: String, abv: String, type: String, brewer: String, country: String,beer_id: Int) {
        self.name = name
        self.image = image
        self.category = category
        self.abv = abv
        self.type = type
        self.brewer = brewer
        self.country = country
        self.beer_id = beer_id
    }
}

//extension Beer: CustomStringConvertible { }

extension Beer {
    convenience init(json: NSDictionary) throws {
        //eenmaal gefaald, kan je hier niet voorbij
        guard let name = json["name"] as? String else{
            throw Service.Error.MissingJsonProperty(name: "name")
        }
        guard let beer_id = json["beer_id"] as? Int else{
            throw Service.Error.MissingJsonProperty(name: "beer_id")
        }
        guard let type = json["type"] as? String else{
            throw Service.Error.MissingJsonProperty(name: "type")
        }
        guard let image = json["image"] as? NSURL else{
            throw Service.Error.MissingJsonProperty(name: "image")
        }
        guard let country = json["country"] as? String else{
            throw Service.Error.MissingJsonProperty(name: "country")
        }
        guard let category = json["category"] as? String else{
            throw Service.Error.MissingJsonProperty(name: "category")
        }
        guard let abv = json["abv"] as? String else{
            throw Service.Error.MissingJsonProperty(name: "abv")
        }
        guard let brewer = json["brewer"] as? String else{
            throw Service.Error.MissingJsonProperty(name: "brewer")
        }

        self.init(name: name, image: image, category: category, abv: abv, type: type, brewer: brewer, country: country, beer_id: beer_id)
    }
}


