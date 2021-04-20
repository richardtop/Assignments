import UIKit

struct SpeciesComponent {
  static func withSection(_ section: PostSpeciesSection) -> Component {
    return FutureComponent({ (context) -> Component in
      let textStyle = context.styleSheet.text
      
      var component: Component = ListComponent(direction: .vertical,
                                               horizontalAlignment: .center,
                                               verticalAlignment: .middle) { add in
                                                add(RemoteImageComponent(url: section.image.url, size: section.image.size))
                                                if let title = section.title {
                                                  add(TextComponent(title, style: context.styleSheet.text.speciesTitle))
                                                }
      }
      
      component = InsetComponent(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), component: component)
      
      component = BackgroundComponent(component: component, fill: .width, configurationBlock: { (background) in
        background.backgroundColor = .white
        background.clipsToBounds = false
        let layer = background.layer
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.3
        layer.cornerRadius = 10
      })
      
      component = ListComponent(direction: .vertical,
                                horizontalAlignment: .center,
                                verticalAlignment: .middle,
                                interItemSpace: 15) { add in
                                  add(TextComponent("SPECIES CAUGHT", style: textStyle.speciesSectionTitle))
                                  add(component)
      }
      
      return component
    })
  }
}
