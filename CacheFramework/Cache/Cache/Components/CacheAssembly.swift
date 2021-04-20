import Foundation

public protocol CacheAssemblyItem {
    func object<T: Cacheable>(key: String) -> T?
    func set<T: Cacheable>(object: T?, key: String)
    func clear()
}

public class CacheAssembly: NSObject {

    let readQueue: DispatchQueue
    let writeQueue: DispatchQueue

    var levels = [CacheAssemblyItem]()

    public init(levels: [CacheAssemblyItem]) {
        self.levels = levels
        self.readQueue = DispatchQueue(label: "CacheAssembly.Read")
        self.writeQueue = DispatchQueue(label: "CacheAssembly.Write")
        super.init()
    }

    // Async

    public func object<T: Cacheable>(key: String, completion: @escaping (T?)-> Void = { _ in return}){
        readQueue.async {
            completion(self._object(key: key))
        }
    }

    public func set<T: Cacheable>(object: T?, key: String, completion: @escaping () -> Void = {_ in return}) {
        writeQueue.async {
            self._set(object: object, key: key)
            completion()
        }
    }

    public func clear(completion: @escaping () -> Void) {
        writeQueue.async {
            self.clear()
            completion()
        }
    }

    // Sync

    public func object<T: Cacheable>(key: String) -> T? {
        var value: T?
        readQueue.sync {
            value = self._object(key: key) as T?
        }
        return value
    }

    public func set<T: Cacheable>(object: T?, key: String) {
        writeQueue.sync {
            self._set(object: object, key: key)
        }
    }

    public func clear() {
        writeQueue.sync {
            self._clear()
        }
    }

    private func _object<T: Cacheable>(key: String) -> T? {
        for (id, cache) in self.levels.enumerated() {
            if let value: T = cache.object(key: key) {
                // If value has been found in level other than top, add it to the upper levels
                if id > 0 {
                    writeQueue.async {
                        for i in 0...id - 1 {
                            self.levels[i].set(object: value, key: key)
                        }
                    }
                }
                return value
            }
        }
        return nil
    }

    private func _set<T: Cacheable>(object: T?, key: String) {
        for cache in self.levels {
            cache.set(object: object, key: key)
        }
    }

    private func _clear() {
        levels.forEach{$0.clear()}
    }
}
