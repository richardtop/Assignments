import UIKit

public enum Result<T> {
  case Success(T)
  case Failure(Error)
}

protocol ComponentProvider {
  func components(offset: Int, count: Int, completion: @escaping (Result<[Component]>) -> Void)
}

class LogicController: ComponentReloadDelegate, CollectionControllerDisplayDelegate {
  /* Minimum number of items that should always be available.
   * Loading of the next batch starts when there are less content available than this number
   */
  var loadMargin = 15
  // Size of the batch to load
  var batchSize = 30
  
  var viewController: CollectionController
  var nodeDataSource: NodeCollectionViewDataSource
  var componentProvider: ComponentProvider
  
  var components = [Component]()
  var context: ComponentContext
  
  var offsetMarker: Int?
  
  init(context: ComponentContext,
       componentProvider: ComponentProvider) {
    self.context = context
    self.componentProvider = componentProvider
    
    self.nodeDataSource = NodeCollectionViewDataSource()
    self.viewController = CollectionController()
    
    viewController.dataSource = nodeDataSource
    viewController.displayDelegate = self
    viewController.logicController = self
    
    components = [Component]()
    self.loadNextData()
  }
  
  func controller(controller: CollectionController, willDisplayItem indexPath: IndexPath) {
    let section = indexPath.section
    if section + loadMargin > nodeDataSource.numberOfSections() {
      loadNextData()
    }
  }
  
  func loadNextData() {
    loadDataWith(offset: components.count, count: batchSize)
  }
  
  func loadDataWith(offset: Int, count: Int) {
    dispatchToBackground {
      if self.offsetMarker != nil {
        return
      }
      
      self.offsetMarker = offset
      self.componentProvider.components(offset: offset, count: count, completion: { (result) in
        switch result {
        case .Failure(let error):
          print(error)
          self.offsetMarker = nil
        case .Success(let components):
          let idxBefore = self.components.count
          let after = idxBefore + components.count - 1
          let indexSet = IndexSet(integersIn: idxBefore...after)
          self.appendNewComponents(components: components)
          self.offsetMarker = nil
          self.insertSections(indexSet)
        }
      })
    }
  }
  
  func appendNewComponents(components: [Component]) {
    var nodes = [[Subnode]]()
    for component in components {
      component.reloadDelegate = self
      let node = self.subnodes(component: component)
      nodes.append(node)
    }
    self.components.append(contentsOf: components)
    self.nodeDataSource.append(sections: nodes)
  }
  
  func subnodes(component: Component) -> [Subnode] {
    let subnodes = NodeTools.simplifiedNodeHierarchy(node: component.node(for: context))
    return subnodes
  }
  
  func reloadData() {
    dispatchToMain {
      self.viewController.reloadData()
    }
  }
  
  func insertSections(_ indexSet: IndexSet) {
    dispatchToMain {
      self.viewController.insertSections(indexSet)
    }
  }
  
  func reload(component: Component) {
    dispatchToBackground {
      guard let index = self.components.index(where: {$0===component}) else {return}
      let newSubnodes = self.subnodes(component: component)
      self.nodeDataSource.setSubnodes(subnodes: newSubnodes, at: index)
      self.dispatchToMain {
        self.viewController.reloadSections(IndexSet([index]))
      }
    }
  }
  
  private func dispatchToBackground(code: @escaping () -> Void) {
    DispatchQueue.global(qos: .userInitiated).async {
      code()
    }
  }
  
  private func dispatchToMain(code: @escaping () -> Void) {
    DispatchQueue.main.async {
      code()
    }
  }
}
