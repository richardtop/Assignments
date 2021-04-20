import UIKit

public protocol ImageProcessingStage {
    func process(image: UIImage?) -> UIImage?
}

public class ImageProcessingPipeline: ImageProcessingStage {

    public let stages: [ImageProcessingStage]

    public init(stages: [ImageProcessingStage]) {
        self.stages = stages
    }

    public func process(image: UIImage?) -> UIImage? {
        if stages.isEmpty {return image}

        var image = image

        for stage in stages {
            image = stage.process(image: image)
        }

        return image
    }
}
