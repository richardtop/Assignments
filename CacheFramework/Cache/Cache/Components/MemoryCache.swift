import Foundation

class ValueWrapper: NSObject {
    let value: Any
    init(value: Any) {
        self.value = value
    }
}

public class MemoryCache: CacheAssemblyItem {

    private var cache: Cache<NSString, NSObject>

    public init(cache: Cache<NSString, NSObject> = Cache<NSString, NSObject>()) {
        self.cache = cache
    }

    public func object<T: Cacheable>(key: String) -> T? {
        let value = cache[key as NSString]

        if let value = value as? ValueWrapper {
            return value.value as? T
        }

        return value as? T
    }

    public func set<T: Cacheable>(object: T?, key: String) {

        var value: NSObject?

        if let object = object as? NSObject {
            value = object
        } else if object != nil {
            value = ValueWrapper(value: object as Any)
        }
        
        cache[key as NSString] = value
    }

    public func clear() {
        cache.removeAllObjects()
    }
}
