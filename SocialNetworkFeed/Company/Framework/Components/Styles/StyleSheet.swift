import UIKit

struct StyleSheet {
  var text = CompanyTextStyles()
}

// Example of a custom TextStyleSheet
struct CompanyTextStyles {
  struct Profile {
    var title: TextStyleProtocol = TextStyle().withFont(.boldSystemFont(ofSize: 16))
    var subtitle: TextStyleProtocol = TextStyle().withFont(.systemFont(ofSize: 14)).ofColor(.darkGray)
  }
  
  var profile = Profile()
  var body: TextStyleProtocol = TextStyle().withFont(.systemFont(ofSize: 16))
  var speciesTitle: TextStyleProtocol = TextStyle().withFont(UIFont(name: "Noteworthy-Bold", size: 20) ?? UIFont.boldSystemFont(ofSize: 20))
  var speciesSectionTitle: TextStyleProtocol = TextStyle().withFont(.boldSystemFont(ofSize: 18)).ofColor(.lightGray)
}

// Default TextStyleSheet modelled as in Pages app
struct TextStyleSheet {
  var title: TextStyleProtocol = TextStyle().withFont(.boldSystemFont(ofSize: 30))
  var subtitle: TextStyleProtocol = TextStyle().ofSize(20)
  var heading1: TextStyleProtocol = TextStyle().withFont(.boldSystemFont(ofSize: 18))
  var heading2: TextStyleProtocol = TextStyle().withFont(.boldSystemFont(ofSize: 16))
  var heading3: TextStyleProtocol = TextStyle().ofSize(14)
  var headingAccent: TextStyleProtocol = TextStyle().withFont(.boldSystemFont(ofSize: 16)).ofColor(.red)
  var body: TextStyleProtocol = TextStyle()
}
