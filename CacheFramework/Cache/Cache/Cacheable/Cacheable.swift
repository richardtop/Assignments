import Foundation

public protocol Cacheable {
    associatedtype CacheableEntity

    func encode() -> Data?

    static func decode(data: Data) -> CacheableEntity?
}
