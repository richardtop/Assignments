import Foundation

extension String: Cacheable {

    public typealias CacheableEntity = String

    public static func decode(data: Data) -> String? {
        return String(data: data, encoding: .utf8)
    }

    public func encode() -> Data? {
        return data(using: .utf8)
    }
}
