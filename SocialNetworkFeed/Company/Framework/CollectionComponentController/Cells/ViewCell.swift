import UIKit

class ViewCell: UICollectionViewCell, NodeUpdatable {
  typealias ViewConfigurationBlock = (UIView) -> ()
  
    override var isHighlighted: Bool {
      didSet {
        alpha = isHighlighted ? 0.5 : 1
      }
    }
  
  func update(node: Node) {
    if let block = node.state as? ViewConfigurationBlock {
      block(self)
    }
  }
  
  override func prepareForReuse() {
    backgroundColor = nil
    layer.shadowOpacity = 0
    layer.cornerRadius = 0
    super.prepareForReuse()
  }
}
