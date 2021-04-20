import UIKit

class TextComponent: ComponentBase {
  let text: NSAttributedString?
  
  init(text: NSAttributedString?) {
    self.text = text
  }
  
  init(_ string: String, style: TextStyleProtocol) {
    self.text = NSAttributedString(string: string, style: style)
  }
  
  override func node(for context: ComponentContext) -> Node {
    var node = Node()
    node.state = text
    node.component = self
    node.translatesIntoView = true
    node.viewType = TextCell.self
    
    let maxWidth = context.sizeRange.max.width
    let textSize = text?.boundingRect(with: CGSize(width: maxWidth, height: .greatestFiniteMagnitude),
                                  options: [.usesLineFragmentOrigin, .usesFontLeading],
                                  context: nil)
    let size = textSize?.size ?? .zero
    node.size = size.constrained(by: context.sizeRange)

    return node
  }
}
