import ObjectMapper

class Photo: Mappable {
  var type: String?
  var id: Int?
  var photo: ImageSet?
  
  required init?(map: Map) {}
  
  func mapping(map: Map) {
    type <- map["type"]
    id <- map["id"]
    photo <- map["photo"]
  }
}

class Catch: Mappable {
  var type: String?
  var id: Int = -1
  var description: String = ""
  var staff_picked: Bool?
  var caught_at_gmt: Date?
  var caught_at_local_time_zone: Date?
  var weight: Double?
  var length: Double?
  var private_fishing_water: Bool?
  var private_position: Bool?
  var id_v2: String?
  var deep_link: String?
  var created_at: Date?
  var owner: User?
  var photos: [Photo]?
  var method: Method?
  var species: Species?

  required init?(map: Map) {}
  
  func mapping(map: Map) {
    type <- map["type"]
    id <- map["id"]
    description <- map["description"]
    staff_picked <- map["staff_picked"]
    caught_at_gmt <- (map["caught_at_gmt"],
                      DateFormatterTransform(dateFormatter: Defaults.jsonToDateFormatter))
    caught_at_local_time_zone <- (map["caught_at_local_time_zone"],
                                  DateFormatterTransform(dateFormatter: Defaults.jsonToDateFormatter))
    weight <- map["weight"]
    length <- map["length"]
    private_fishing_water <- map["private_fishing_water"]
    private_position <- map["private_position"]
    id_v2 <- map["id_v2"]
    deep_link <- map["deep_link"]
    created_at <- (map["created_at"],
                   DateFormatterTransform(dateFormatter: Defaults.jsonToDateFormatter))
    owner <- map["owner"]
    photos <- map["photos"]
    method <- map["method"]
    species <- map["species"]
  }
}
