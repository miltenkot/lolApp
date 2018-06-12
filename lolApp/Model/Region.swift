
import Foundation

class Region {
    
    static var regions = [
        "RU": "ru",
        "BR": "br1",
        "KR": "kr",
        "OC": "oc1",
        "JAPAN": "jp1",
        "NA": "na1",
        "EUEN": "eun1",
        "EUW": "euw1",
        "LA1": "la1",
        "LA2": "la2"
    ]
    
    static func getRegions() -> [String: String]{
        return self.regions
    }
    struct config {
        static var region = "EUW"
    }
    
    class var region: String {
        get {
            return regions[config.region]!
            
        }
        set {
            config.region = newValue
            
        }
    }
}
