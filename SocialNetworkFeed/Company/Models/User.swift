import ObjectMapper

class User: Mappable {
  var id: Int?
  var type: String?
  var nickname: String?
  var first_name: String?
  var last_name: String?
  var country_code: String?
  var state_code: String?
  var created_at: Date?
  var featured: Bool?
  var is_premium: Bool?
  var onboarded: Bool?
  var avatar: ImageSet?
  
  required init?(map: Map) {}
  
  func mapping(map: Map) {
    id <- map["id"]
    type <- map["type"]
    nickname <- map["nickname"]
    first_name <- map["first_name"]
    last_name <- map["last_name"]
    country_code <- map["country_code"]
    state_code <- map["state_code"]
    created_at <- (map["created_at"], DateFormatterTransform(dateFormatter: Defaults.jsonToDateFormatter))
    featured <- map["featured"]
    is_premium <- map["onboarded"]
    onboarded <- map["onboarded"]
    avatar <- map["avatar"]
  }
}
