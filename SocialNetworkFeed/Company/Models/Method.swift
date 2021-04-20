import ObjectMapper

class Method: Mappable {
  var type: String?
  var id: Int?
  var localized_name: String?
  var cover_image: ImageSet?
  var followers_count: Int?
  
  required init?(map: Map) {}
  
  func mapping(map: Map) {
    type <- map["type"]
    id <- map["id"]
    localized_name <- map["localized_name"]
    cover_image <- map["cover_image"]
    followers_count <- map["followers_count"]
  }
}
