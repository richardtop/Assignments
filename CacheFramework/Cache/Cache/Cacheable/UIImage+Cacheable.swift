import UIKit

extension UIImage: Cacheable {

    public typealias CacheableEntity = UIImage

    public static func decode(data: Data) -> UIImage? {
        return UIImage(data: data)
    }

    public func encode() -> Data? {
        guard let cgImage = cgImage else {return nil}
        switch cgImage.alphaInfo {
        case .none, .noneSkipLast, .noneSkipFirst:
            return UIImageJPEGRepresentation(self, 1)
        default:
            return UIImagePNGRepresentation(self)
        }
    }
}
