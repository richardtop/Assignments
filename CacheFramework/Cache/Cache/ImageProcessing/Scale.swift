import UIKit

public struct Scale: ImageProcessingStage {

    public let scaleClosure: (UIImage) -> CGFloat

    public init(scale: CGFloat) {
        scaleClosure = {_ in return scale}
    }

    init(scaleCalculationClosure: @escaping (UIImage) -> CGFloat) {
        scaleClosure = scaleCalculationClosure
    }

    public func process(image: UIImage?) -> UIImage? {
        guard let image = image else {
            return nil
        }

        let scale = scaleClosure(image)

        let newSize = image.size.applying(CGAffineTransform(scaleX: scale, y: scale))
        let isOpaque = false
        let displayScaleFactor: CGFloat = 0.0

        UIGraphicsBeginImageContextWithOptions(newSize, isOpaque, displayScaleFactor)

        image.draw(in: CGRect(origin: .zero, size: newSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        
        return scaledImage
    }
}
