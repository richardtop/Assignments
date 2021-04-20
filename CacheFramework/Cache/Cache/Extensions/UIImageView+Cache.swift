import UIKit

extension UIImageView {
    private struct AssociatedKeys {
        static var cache_networkTask = "cache_networkTask"
    }

    var cache_networkTask: URLSessionDataTask? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.cache_networkTask) as? URLSessionDataTask
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.cache_networkTask,
                    newValue as URLSessionDataTask?,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }

    public func setImage(with url: URL?,
                         cacheAssembly: CacheAssembly = Defaults.cacheAssembly,
                         imagePipeline: ImageProcessingPipeline = Defaults.imagePipeline,
                         completionHandler: @escaping () -> () = {_ in return}) {
        guard let url = url else {
            self.cancelTask()
            return
        }

        if self.cache_networkTask != nil {
            self.cancelTask()
        }

        // Check cache

        if let cachedImage: UIImage = cacheAssembly.object(key: url.absoluteString) {
            self.setImage(image: cachedImage, completionHandler: completionHandler)
            return
        }

        // Fetch from network, if not found

        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        let task = URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data, let newImage = UIImage(data: data) else { return }
            // Process image before saving & setting to ImageView
            let image = imagePipeline.process(image: newImage)
            // Setting image to ImageView on Main thread
            self.setImage(image: image, completionHandler: completionHandler)

            // Saving image into cache proceeds on the other thread (not main), hence sync call
            cacheAssembly.set(object: image, key: url.absoluteString)
        }
        self.cache_networkTask = task
        task.resume()
    }

    private func setImage(image: UIImage?, completionHandler: @escaping () -> () = {_ in return}) {
        DispatchQueue.main.async {
            self.image = image
            completionHandler()
        }
    }

    func cancelTask() {
        cache_networkTask?.cancel()
        cache_networkTask = nil
        image = nil
    }
}
