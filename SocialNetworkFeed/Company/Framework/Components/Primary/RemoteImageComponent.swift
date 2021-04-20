import UIKit

class RemoteImageComponentState {
  var url: URL?
  var placeholder: UIImage?
  var size: CGSize?
  var cornerRadius: CGFloat?
  
 init(url: URL? = nil, placeholder: UIImage? = nil, size: CGSize? = nil, cornerRadius: CGFloat? = nil) {
  self.url = url
  self.placeholder = placeholder
  self.size = size
  self.cornerRadius = cornerRadius
  }
}

class RemoteImageComponent: ComponentBase {
  let state: RemoteImageComponentState
  
  init(state: RemoteImageComponentState) {
    self.state = state
  }
  
  init(url: URL? = nil, placeholder: UIImage? = nil, size: CGSize? = nil, cornerRadius: CGFloat? = nil) {
    self.state = RemoteImageComponentState(url: url, placeholder: placeholder, size: size, cornerRadius: cornerRadius)
  }
  
  override func node(for context: ComponentContext) -> Node {
    var node = Node()
    
    node.state = state
    node.component = self
    node.translatesIntoView = true
    node.viewType = RemoteImageCell.self
    
    var size = state.size ?? state.placeholder?.size ?? .zero
    let constrainedSize = size.constrained(by: context.sizeRange)
    
    // Keep aspect ratio if the image is larger on one of the dimensions
    let aspectRatio = size.width / size.height
    if !aspectRatio.isNaN {
      if size.width == constrainedSize.width {
        size = CGSize(width: constrainedSize.height * aspectRatio, height: constrainedSize.height)
      } else if size.height == constrainedSize.height {
        size = CGSize(width: constrainedSize.width, height: constrainedSize.width / aspectRatio)
      }
    } else {
      size = constrainedSize
    }

    node.size = size
    
    return node
  }
}
