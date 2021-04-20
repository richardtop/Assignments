import Kingfisher

class RemoteImageCell: CollectionCellBase<UIImageView>, NodeUpdatable {
  override init(frame: CGRect) {
    super.init(frame: frame)
    view.contentMode = .scaleAspectFill
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func update(node: Node) {
    guard let state = node.state as? RemoteImageComponentState else {return}
    var options = [KingfisherOptionsInfoItem]()
    if let radius = state.cornerRadius {
      let processor = RoundCornerImageProcessor(cornerRadius: radius)
      options.append(.processor(processor))
    }
    view.kf.setImage(with: state.url, placeholder: state.placeholder, options: options)
  }
  
  override func prepareForReuse() {
    view.kf.setImage(with: nil)
    super.prepareForReuse()
  }
}
