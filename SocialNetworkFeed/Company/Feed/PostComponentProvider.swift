import Alamofire
import AlamofireObjectMapper

class PostComponentProvider: ComponentProvider {
  func components(offset: Int, count: Int, completion: @escaping (Result<[Component]>) -> Void) {
    let page = offset / 10 + 1 // API starts at page 1,
    let URL = "https://companydomain.com/catches?page=\(page)&verbosity=2"
    Alamofire.request(URL).responseArray { (response: DataResponse<[Catch]>) in
      if let error = response.result.error {
        completion(Result.Failure(error))
        return
      }
      var components = [Component]()
      if let catches = response.result.value {
        components = catches.map(Post.init).map(PostComponent.init)
      }
      completion(Result.Success(components))
    }
  }
}
