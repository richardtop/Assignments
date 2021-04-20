import ObjectMapper

class Species: Mappable {
  var type: String?
  var id: Int?
  var name: String?
  var species: String?
  var image: URL?
  var photo: ImageSet?
  var max_weight: Double?
  var followers_count: Int?
  var localized_name: String?
  var localized_alternative_names = [String]()

  required init?(map: Map) {}
  
  func mapping(map: Map) {
    type <- map["type"]
    id <- map["id"]
    name <- map["name"]
    species <- map["species"]
    image <- (map["image"], URLTransform())
    photo <- map["photo"]
    max_weight <- map["max_weight"]
    followers_count <- map["followers_count"]
    localized_name <- map["localized_name"]
    localized_alternative_names <- map["localized_alternative_names"]
  }
}
