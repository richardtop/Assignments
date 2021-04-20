import Foundation

public struct RoundCorners: ImageProcessingStage {

    public let radius: CGFloat

    public init(radius: CGFloat = 0) {
        self.radius = radius
    }

    public func process(image: UIImage?) -> UIImage? {
        guard let image = image else {
            return nil
        }

        UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        let rect = CGRect(origin: .zero, size: image.size)

        let path = UIBezierPath(roundedRect: rect, cornerRadius: radius).cgPath
        context.beginPath()
        context.addPath(path)
        context.closePath()
        context.clip()

        image.draw(in: rect)

        let processedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return processedImage
    }
}
