

import Foundation
import RealmSwift

class RealmQuoteObject: Object {
    
    @Persisted var jokeText: String = ""
    @Persisted var category = ""
    @Persisted var downloadDate = Date.now
    
}
