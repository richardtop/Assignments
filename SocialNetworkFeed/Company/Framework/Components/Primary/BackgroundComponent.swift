import UIKit

enum BackgroundComponentFill {
  case none
  case width
  case height
}

struct BackgroundComponentState {
  var component: Component
  var fill: BackgroundComponentFill
  let configurationBlock: (UIView) -> Void
}

class BackgroundComponent: ComponentBase {
  var state: BackgroundComponentState
  
  init(state: BackgroundComponentState) {
    self.state = state
    super.init()
    self.state.component.parent = self
  }
  
  convenience init(component: Component, fill: BackgroundComponentFill = .none, configurationBlock: @escaping (UIView) -> Void) {
    self.init(state: BackgroundComponentState(component: component, fill: fill, configurationBlock: configurationBlock))
  }
  
  override func node(for context: ComponentContext) -> Node {
    var node = Node()
    node.component = self
    
    let childNode = state.component.node(for: context)
    node.size = childNode.size.constrained(by: context.sizeRange)
    node.viewType = ViewCell.self
    node.translatesIntoView = true
    node.state = state.configurationBlock
    node.subnodes = [Subnode(node: childNode, at: .zero)]
    
    switch state.fill {
    case .width:
      node.size.width = context.sizeRange.max.width
    case .height:
      node.size.height = context.sizeRange.max.height
    default:
      break
    }

    return node
  }
}
