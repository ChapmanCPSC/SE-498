import Firebase

protocol FIRStorageDownloadable
{
    var location: String? { get }
}

extension FIRStorageDownloadable where Self: FIRModel
{
    var location: String? { return self.get("profilepic") }
    
    func getDownloadURL(completion: @escaping (URL?, Error?) -> Void)
    {
        guard let ref = self.getStorageRef() else
        {
            completion(nil, NSError(domain: "No storage reference found", code: 0, userInfo: nil))
            return
        }
        
        ref.downloadURL(completion: completion)
    }
    
    func getData(withMaxSize maxSize: Int64, completion: @escaping (Foundation.Data?, Error?) -> Void)
    {
        guard let ref = self.getStorageRef() else
        {
            completion(nil, NSError(domain: "No storage reference found", code: 0, userInfo: nil))
            return
        }
        
        ref.getData(maxSize: maxSize, completion: completion)
    }
    
    fileprivate func getStorageRef() -> StorageReference?
    {
        guard let loc = location else
        {
            return nil
        }
        
        return Storage.storage().reference(withPath: loc)
    }
}
