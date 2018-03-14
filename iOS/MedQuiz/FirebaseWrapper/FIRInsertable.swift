import Foundation
import Firebase

protocol FIRInsertable
{
    static var COLLECTION_NAME: String { get }
}

extension FIRInsertable where Self: FIRModel
{
    static func Insert(data: [String: Any], completion: ((Self) -> Void)? = nil)
    {
        let ref = Database.database().reference().child(COLLECTION_NAME).childByAutoId()
        ref.updateChildValues(data)
        
        ref.observe(.value) { (snapshot: DataSnapshot) in completion?(Self.init(snapshot: snapshot)) }
    }
}
