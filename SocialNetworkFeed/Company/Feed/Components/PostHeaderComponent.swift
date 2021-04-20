import Foundation

struct PostHeaderComponent {
  static func withPostHeader(_ header: PostHeader) -> Component {
    return FutureComponent({ (context) -> Component in
      let textStyles = context.styleSheet.text
      
      let titles = header.titles.map{ title in
        TextComponent(title, style: textStyles.profile.title)
      }
      
      let subtitles = header.subtitles.map{ subtitle in
        TextComponent(subtitle, style: textStyles.profile.subtitle)
      }
      
      let headerTitleList = ListComponent(direction: .horizontal,
                                          horizontalAlignment: .left,
                                          verticalAlignment: .bottom,
                                          interItemSpace: 15,
                                          components: titles)
      
      let headerSubtitleList = ListComponent(direction: .horizontal,
                                             horizontalAlignment: .left,
                                             verticalAlignment: .bottom,
                                             interItemSpace: 15,
                                             components: subtitles)
      
      let headerTextBlock = ListComponent(direction: .vertical,
                                          horizontalAlignment: .left,
                                          verticalAlignment: .bottom,
                                          interItemSpace: 0,
                                          components: [
                                            headerTitleList,
                                            headerSubtitleList
        ])
      
      
      
      let header: Component = ListComponent(direction: .horizontal,
                                            horizontalAlignment: .left,
                                            verticalAlignment: .top,
                                            interItemSpace: 10) { add in
                                              for image in header.remoteImages {
                                                add(RemoteImageComponent(url: image.url, size: image.size, cornerRadius: 300))
                                              }
                                              add(headerTextBlock)
      }
      
      return header
    })
  }
}
