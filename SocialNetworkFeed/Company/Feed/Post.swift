import Foundation
import CoreGraphics

struct PostHeader {
  var remoteImages = [RemoteImage]()
  var titles = [String]()
  var subtitles = [String]()
}

struct RemoteImage {
  let url: URL
  let size: CGSize
}

struct PostSpeciesSection {
  let image: RemoteImage
  let title: String?
}

struct Post {
  var header: PostHeader?
  var photo: RemoteImage?
  var text: String?
  var species: PostSpeciesSection?
  
  init(catchModel: Catch) {
    var header = PostHeader()
    if let user = catchModel.owner {
      // NickName is used by default, a full name is used if user has no nickname
      let name = user.nickname ?? (user.first_name ?? "" + " " + (user.last_name ?? ""))
      header.titles.append(name)
      
      
      if let avatar = user.avatar?.firstImageFittingWidth(width: 40) {
        if let url = avatar.url, let width = avatar.width, let height = avatar.height {
          header.remoteImages.append(RemoteImage(url: url, size: CGSize(width: width, height: height)))
        }
      }
    }
    
    if let method = catchModel.method?.localized_name {
      header.subtitles.append(method)
    }
    
    if let catchDate = catchModel.caught_at_gmt {
      let dateText = Defaults.dateToStringFormatter.string(from: catchDate)
      header.subtitles.append(dateText)
    }
    
    var image: RemoteImage?
    if let photo = catchModel.photos?.first?.photo?.firstImageFittingWidth(width: 600) {
      if let url = photo.url, let width = photo.width, let height = photo.height {
        image = RemoteImage(url: url, size: CGSize(width: width, height: height))
      }
    }
    
    var speciesSection: PostSpeciesSection?
    if let species = catchModel.species {
      if let image = species.photo?.firstImageFittingWidth(width: 300) {
        if let url = image.url, let width = image.width, let height = image.height {
          speciesSection = PostSpeciesSection(image: RemoteImage(url: url, size: CGSize(width: width, height: height)),
                                              title: species.localized_name ?? species.name)
        }
      }
    }
    
    self.header = header
    self.photo = image
    self.text = catchModel.description
    self.species = speciesSection
  }
}
