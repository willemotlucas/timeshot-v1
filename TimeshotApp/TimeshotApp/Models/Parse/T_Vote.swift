import Foundation
import Parse

class T_Vote : PFObject, PFSubclassing {
    
    @NSManaged var toPost: T_Post?
    @NSManaged var fromUser: PFUser?
    @NSManaged var isLiked: Bool
    
    
    
    //MARK: PFSubclassing Protocol
    static func parseClassName() -> String {
        return "Vote"
    }
    
    
    override init () {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }
    
}