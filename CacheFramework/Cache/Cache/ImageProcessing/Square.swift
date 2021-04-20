import UIKit

public struct Square: ImageProcessingStage {

    public init() {}
    
    public func process(image: UIImage?) -> UIImage? {
        guard let image = image else {
            return nil
        }

        let w = image.size.width
        let h = image.size.height

        let side = min(w, h)

        let x = (side - w) / 2
        let y = (side - h) / 2

        let cropRect = CGRect(x: x, y: y, width: side, height: side)

        UIGraphicsBeginImageContextWithOptions(cropRect.size, false, 0.0)

        image.draw(at: CGPoint(x: x, y: y))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
