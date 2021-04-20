//
//  AppDelegate.swift
//  Assignment
//
//

import UIKit
import Dispatch
import Cache

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITableViewDataSource {
    struct Item {
        let title: String
        let imageUrl: URL
    }

    var tableView: UITableView!
    var window: UIWindow?
    var items = [Item]()

    // Separate cache for JSON with persistence

    let jsonCache = CacheAssembly(levels: [MemoryCache(),
                                           DiskCache(name: "JSONCache")])

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        setupCache()

        window = UIWindow(frame: UIScreen.main.bounds)
        let tableController = UITableViewController()
        window?.rootViewController = tableController
        window?.makeKeyAndVisible()

        let tableView = tableController.tableView!
        tableView.dataSource = self
        tableView.rowHeight = 100
        self.tableView = tableView

        let url = URL(string: "https://s3.amazonaws.com/work-project-image-loading/images.json")!

        // Check if JSON is available in cache

        if let json: JSON = jsonCache.object(key: url.absoluteString) {
            switch json {
            case .dictionary(let dictionary):
                updateTable(json: dictionary)
                return true
            default:
                break
            }
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                let json = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] else {
                    return
            }

            let js = JSON.dictionary(json as [String : AnyObject])
            self.jsonCache.set(object: js, key: url.absoluteString)
            self.updateTable(json: json)
            }.resume()

        return true
    }

    func updateTable(json: [String: Any]) {
        DispatchQueue.main.async {
            guard let items = json["images"] as? [[String: String]] else {
                return
            }
            self.items = items.flatMap { i in i["title"].flatMap { title in i["url"].flatMap { URL(string: $0) }.map { url in Item(title: title, imageUrl: url) } } }
            self.tableView.reloadData()
        }
    }

    func setupCache() {

        // Example of ImagePipeline

        Defaults.imagePipeline = ImageProcessingPipeline(stages: [Scale(scale: 0.25),
                                                                  Square(),
                                                                  RoundCorners(radius: 1000)])

        // Custom cache with cost limit and cost calculation closure for images

        let cache = Cache<NSString, NSObject>()
        cache.totalCostLimit = 10_000_000
        cache.costCalculationClosure = {_, object in
            guard let image = object as? UIImage else {
                return 0
            }
            return Int(image.size.width * image.size.height) * 3
        }

        // 2 level cache with persistence

        Defaults.cacheAssembly = CacheAssembly(levels: [MemoryCache(cache: cache),
                                                        DiskCache(name: "ImageCache")])
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = "item"
        let cell = tableView.dequeueReusableCell(withIdentifier: id) ?? UITableViewCell(style: .default, reuseIdentifier: id)

        let item = items[indexPath.row]
        cell.textLabel?.text = item.title

        cell.imageView?.setImage(with: item.imageUrl, completionHandler: {
            cell.setNeedsLayout()
        })
        
        return cell
    }
}
