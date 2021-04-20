import Foundation

public enum JSON: Cacheable {
    public typealias CacheableEntity = JSON

    case array([Any])
    case dictionary([String: Any])

    public var value: Any {
        switch self {
        case .array(let array):
            return array
        case .dictionary(let dictionary):
            return dictionary
        }
    }

    public func encode() -> Data? {
        return try? JSONSerialization.data(withJSONObject: value, options: JSONSerialization.WritingOptions())
    }

    public static func decode(data: Data) -> CacheableEntity? {
        let jsonObject = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
        switch jsonObject {
        case let dictionary as [String: AnyObject]:
            return JSON.dictionary(dictionary)
        case let array as [AnyObject]:
            return JSON.array(array)
        default:
            return nil
        }
    }
}
