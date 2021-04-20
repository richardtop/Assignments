import Foundation

public struct Defaults {
    public static var cacheAssembly: CacheAssembly = CacheAssembly(levels: [MemoryCache()])
    public static var imagePipeline: ImageProcessingPipeline = ImageProcessingPipeline(stages: [])
    public static var recorder: Recorder? = ConsolePrinter()
}
