import UIKit

class PostComponent: ComponentBase {
  
  var component: Component
  
  init(post: Post) {
    self.component = FutureComponent({ (context) -> Component in
      let textStyles = context.styleSheet.text
      
      var components = [Component]()
      if let header = post.header {
        let headerComponent = InsetComponent(insets: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0),
                                             component: PostHeaderComponent.withPostHeader(header))
        components.append(headerComponent)
      }
      
      if let photo = post.photo {
        let photoComponent = InsetComponent(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10),
                                            component: RemoteImageComponent(url: photo.url, size: photo.size))
        components.append(photoComponent)
      }
      
      if let text = post.text {
        let textComponent = TextComponent(text, style: textStyles.body)
        components.append(textComponent)
      }
      
      if let species = post.species {
        let speciesComponent = SpeciesComponent.withSection(species)
        components.append(speciesComponent)
      }
      
      let post = ListComponent(direction: .vertical,
                               horizontalAlignment: .left,
                               verticalAlignment: .bottom,
                               interItemSpace: 5,
                               components: components)
      
      let inset = InsetComponent(insets: UIEdgeInsets(top: 10, left: 20, bottom: 20, right: 20),
                                 component: post)
      
      let background = BackgroundComponent(component: inset, fill: .width, configurationBlock: { (backgroundView) in
        backgroundView.backgroundColor = .white
      })

      return background
    })
  }
  
  override func node(for context: ComponentContext) -> Node {
    return component.node(for: context)
  }
}
