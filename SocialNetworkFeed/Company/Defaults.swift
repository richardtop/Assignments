import Foundation

struct Defaults {
  static var jsonToDateFormatter = DateFormatter(withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSZ",
                                                 locale: "en_US_POSIX")
  static var dateToStringFormatter = DateFormatter(withFormat: "d MMMM yyyy",
                                                   locale: String(describing: Locale.current))
}
