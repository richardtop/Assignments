import UIKit

class ImageCell: CollectionCellBase<UIImageView>, NodeUpdatable {
  func update(node: Node) {
    if let image = node.state as? UIImage? {
      view.image = image
    }
  }
  
  override func prepareForReuse() {
    view.image = nil
    super.prepareForReuse()
  }
}

