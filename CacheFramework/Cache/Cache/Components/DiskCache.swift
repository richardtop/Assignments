import Foundation

public class DiskCache: CacheAssemblyItem {
    let path: String
    let fileManager = FileManager()

    public init(name: String) {
        do {
            let url = try fileManager.url(for: .cachesDirectory,
                                          in: .userDomainMask,
                                          appropriateFor: nil,
                                          create: true)
            path = url.appendingPathComponent(name, isDirectory: true).path
            try createDirectory(at: path)
        } catch {
            fatalError("Unable to initialize disk cache: \(error)")
        }
    }

    func createDirectory(at path: String) throws {
        if !fileManager.fileExists(atPath: path) {
            try fileManager.createDirectory(atPath: path,
                                            withIntermediateDirectories: true,
                                            attributes: nil)
        }
    }

    public func object<T: Cacheable>(key: String) -> T? {
        let path = filePathForKey(key: key)
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return nil
        }

        guard let object = T.decode(data: data) as? T else {
            return nil
        }

        return object
    }

    public func set<T: Cacheable>(object: T?, key: String) {
        let path = filePathForKey(key: key)
        if let object = object {
            fileManager.createFile(atPath: path, contents: object.encode(), attributes: nil)
        } else {
            do {
                try fileManager.removeItem(atPath: path)
            } catch {
                let message = "Error removing object from disk at path \(path), \(error)"
                Defaults.recorder?.record(entry: message)
            }
        }
    }

    public func clear() {
        do {
            try fileManager.removeItem(atPath: path)
            try createDirectory(at: path)
        } catch {
            let message = "Error clearing cache directory at path \(path), \(error)"
            Defaults.recorder?.record(entry: message)
        }
    }

    private func filePathForKey(key: String) -> String {
        let escapedKey = key.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        return "\(path)/\(escapedKey)"
    }
}
