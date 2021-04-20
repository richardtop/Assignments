import ObjectMapper

class CoverImage: Mappable {
  var id: Int?
  var type: String?
  var image: ImageSet?
  
  required init?(map: Map) {}
  
  func mapping(map: Map) {
    id <- map["id"]
    type <- map["type"]
    image <- map["image"] 
  }
}
