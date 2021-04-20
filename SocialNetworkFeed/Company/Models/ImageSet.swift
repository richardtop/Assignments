import ObjectMapper

class ImageSize: Mappable {
  var type: String?
  var geometry: String?
  var url: URL?
  var name: String?
  var width: Int?
  var height: Int?
  
  required init?(map: Map) {}
  
  func mapping(map: Map) {
    type <- map["type"]
    geometry <- map["geometry"]
    url <- (map["url"], URLTransform(shouldEncodeURLString: false, allowedCharacterSet: .urlFragmentAllowed))
    name <- map["name"]
    width <- map["width"]
    height <- map["height"]
  }
}

class ImageSet: Mappable {
  var type: String?
  var sizes = [ImageSize]()
  
  required init?(map: Map) {}
  
  func mapping(map: Map) {
    type <- map["type"]
    sizes <- map["sizes"]
  }
  
  func firstImageFittingWidth(width: CGFloat) -> ImageSize? {
    let sorted = sizes.filter{$0.width != nil}.sorted{$0.width! < $1.width!}
    if let first = sorted.first(where: {$0.width! > Int(width)}) {
      return first
    }
    // Return largest possible image if there are no big enough
    return sorted.last
  }
}
