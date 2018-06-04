
import Foundation

class URLProvider {
    
    public static func summonerName(inRegion region: String, withSummonerName name: String) -> String {
        return "https://\(region).api.riotgames.com/lol/summoner/v3/summoners/by-name/\(name)"
    }
    
    public static func spectatorsInfo(inRegion region: String, withSummonerId id: Int) -> String {
        return "https://\(region).api.riotgames.com/lol/spectator/v3/active-games/by-summoner/\(id)"
    }
    
    public static func avatarImage(withProfileIconId: Int) -> String {
        return "http://ddragon.leagueoflegends.com/cdn/6.24.1/img/profileicon/\(withProfileIconId).png"
    }
    
}
