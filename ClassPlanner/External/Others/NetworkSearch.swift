import Foundation
import Combine

// https://betterprogramming.pub/search-bar-and-combine-in-swift-ui-46f37cec5a9f for more info about how this thing works

//class ProductViewModel: ObservableObject {
//
//    var subscription: Set<AnyCancellable> = []
//
//    @Published private (set) var courses: [Course] = []
//
//    @Published var searchText: String = String()
//
//    // MARK:- Initiliazer for product via model.
//
//    init() {
//        $searchText
//            .debounce(for: .milliseconds(800), scheduler: RunLoop.main) // debounces the string publisher, such that it delays the process of sending request to remote server.
//            .removeDuplicates()
//            .map({ (string) -> String? in
//                if string.count < 1 {
//                    self.courses = []
//                    return nil
//                }
//
//                return string
//            }) // prevents sending numerous requests and sends nil if the count of the characters is less than 1.
//            .compactMap{ $0 } // removes the nil values so the search string does not get passed down to the publisher chain
//            .sink { (_) in
//                //
////            } receiveValue: { [unowned self] (searchField) in
////                searchItems(searchText: searchField)
//            }.store(in: &subscription)
//    }
    
    
//    private func searchItems(searchText: String) {
//
//        NetworkManager.shared.sendRequest(to: ApiConstants.ProductSearchPath.description, model: Products.self, queryItems: ["name": searchText])
//            .receive(on: RunLoop.main)
//            .sink { (completed) in
//                //
//            } receiveValue: { [self] (searchedProducts) in
//                products = searchedProducts
//            }.store(in: &subscription)
//    }
//
//}
