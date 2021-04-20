# Company iOS home assignment - Description of solution

## Intro

I've focused on creating a set of small components, using which it would be possible to compose the needed cache logic.
Then, I've provided examples of cache logic for both images and JSON.

## Architecture

The architecture of this framework is simple: it's built using protocols. The framework itself could be broken down into 3 parts:
- Cache (Memory, Disk)
- Image processing (Scale, Rounded Corners, Square)
- Connecting 

## Cache

### Cacheable Protocol

Any entity can be cached if it supports `Cacheable` protocol: an entity must be able to serialize and de-serialize itself, so it could be stored on disk.
Custom protocol is used instead of `NSCoding` to support Value types. With `Codable` protocol `Cacheable` will not be needed.

### Cache

A wrapper class around `NSCache` supporting subscript and cost calculation closure.
With `Cache` it is possible to encapsulate memory caching logic without creating a separate class with `NSCache`. 
`Cache` does not support value types.

### MemoryCache

`MemoryCache` makes it possible to store value types in memory by wrapping them inside `NSObject`-based subclass, `ValueWrapper`.

### DiskCache

`DiskCache` is responsible for storing to and retrieving files from disk.

### CacheAssembly

Both `MemoryCache` and `DiskCache` conform to `CacheAssemblyItem` protocol, so they can be stacked to provide multi-level cache hierarchy.
`CacheAssembly` is responsible for providing access methods to the client and encapsulating the actual setup used. It has both sync and async methods.
`CacheAssembly` should be initialized with array of `CacheAssemblyItems`, where the item having lower order should be faster. For example: `[MemoryCache, DiskCache, VerySlowCache]`
At first, it will try to fetch resource from the fastest cache. If the resource has been found in slower caches, it will automatically update faster ones and return it.

### Recorder

A protocol to log errors. In the example, all the errors are printed to console. However, it is possible to create custom `Recorder` and connect it to remote analytics platform.

## ImageProcessingPipeline
`ImageProcessingPipeline` consists of multiple `ImageProcessingStages`. A stage takes `UIImage?` as an input and returns `UIImage?` as an output, so that a unique set of stages could be used for processing images.
In example I use these stages in the following order:
- Scale - to reduce size of the image, speed up processing and use less memory
- Square - to make image square
- RoundCorners - I use high value for corner radius, so the output is the image masked with a circle

It is implemented with objects and structs, however, the same result could be accomplished usign functions and currying.    


## Defaults

`Defaults` provide default settings for the `Cache` framework. `Defaults` can be modified, so the global `Cache` behavior is altered.

## UIImageView+Cache.

A convenience extension to fix bug when images are appearing out of order and make it easier for the client to use. It attaches network task for image downloading to the particular `UIImageView` using Associated Objects. Associated Objects is a common way to add stored properties to the SDK classes.

`setImage` function takes multiple arguments, such as `CacheAssembly` and `ImagePipeline`. If no arguments provided, configurations stored in `Defaults` are used.