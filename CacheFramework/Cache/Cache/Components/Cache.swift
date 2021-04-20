import Foundation

public class Cache<KeyType, ObjectType> where KeyType : AnyObject, ObjectType : AnyObject {

    public let cache = NSCache<KeyType, ObjectType>()
    public var costCalculationClosure: (KeyType, ObjectType) -> Int

    public init() {
        self.costCalculationClosure = {_, _ in
            return 0
        }
    }

    public subscript(key: KeyType) -> ObjectType? {
        get {
            return cache.object(forKey: key as KeyType)
        }
        set {
            if let value = newValue {
                cache.setObject(value, forKey: key as KeyType, cost: costCalculationClosure(key, value))
            } else {
                cache.removeObject(forKey: key as KeyType)
            }
        }
    }

    public func removeAllObjects() {
        cache.removeAllObjects()
    }

    public var totalCostLimit: Int {
        get {
            return cache.totalCostLimit
        }
        set (value) {
            cache.totalCostLimit = value
        }
    }

    public var countLimit: Int {
        get {
            return cache.countLimit
        }
        set (value) {
            cache.countLimit = value
        }
    }
}
