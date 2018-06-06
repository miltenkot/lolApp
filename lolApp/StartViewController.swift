
import UIKit
import DropDown
import Alamofire
import Alamofire_Synchronous
import SwiftyJSON
import ChameleonFramework

class StartViewController: UIViewController {
    
    @IBOutlet var infoGameView: UIView!
    @IBOutlet weak var imageOfSummoner: UIImageView!
    
    @IBOutlet weak var gameLenghtTimerLabel: UILabel!
    @IBOutlet weak var searchingNameOfSummoner: UITextField!
    @IBOutlet weak var nameOfSummoner: UILabel!
    @IBOutlet weak var gameStatus: UILabel!
    @IBOutlet weak var regionButton: UIButton!
    
    private var imageURL = ""
    private var APIURL_Spect = ""
    private var APIURL_Summ = ""
    private let gameDataModel = GameDataModel()
    private let userDataModel = UserDataModel()
    private let dict: [String: String] = Region.getRegions()
    private let changeRegion = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDropDowns()
        searchingNameOfSummoner.delegate = self
    }
    
    
    func setupDropDowns() {
        setupChangeRegion()
    }
    
    //MARK: - DropDown Menu
    
    func setupChangeRegion() {
        changeRegion.anchorView = regionButton
        changeRegion.dataSource = Array(dict.keys)
        changeRegion.selectionAction = { [weak self]
            index, item in
            self?.regionButton.setTitle(item, for: .normal)
        }
    }
    //MARK: - URL Data Function
    
    func checkLolName(region:String, summName: String) {
        APIURL_Summ = URLProvider.summonerName(inRegion: region, withSummonerName: summName)
        print(APIURL_Summ)
        getLolInfoUser(url: APIURL_Summ, parameters: params)
    }
    
    func checkLolStatus(region: String,summId: Int) {
        APIURL_Spect = URLProvider.spectatorsInfo(inRegion: region, withSummonerId: summId)
        print(APIURL_Spect)
        getLolInfo(url: APIURL_Spect, parameters: params)
    }
    
    func getLolInfoUser(url: String, parameters: [String: String]) {
        let response = Alamofire.request(url, parameters: parameters).responseJSON()
        let json : JSON  = JSON(response.result.value!)
        self.updateGameUser(json: json )
        self.updateUIUser()
    }
    
    func getLolInfo(url: String, parameters: [String: String]) {
        let response = Alamofire.request(url, parameters: parameters).responseJSON()
        let json : JSON  = JSON(response.result.value!)
        self.updateGameStatus(json: json)
        self.updateUIStatus()
    }
    
    func updateGameUser(json: JSON) {
        if let summ = json[SUMMONER_NAME].string {
            userDataModel.name = summ
            userDataModel.profileIconId = json[PROFILE_ICON_ID].intValue
            userDataModel.id = json[SUMMONER_ID].intValue
        }
        else {
            userDataModel.name = UNKNOWN_USER_NAME
            userDataModel.profileIconId = 0
            userDataModel.id = 0
        }
        print(userDataModel.name)
        print(userDataModel.id)
    }
    
    func updateGameStatus(json: JSON) {
        if let time = json[GAME_START_TIME].double {
            gameDataModel.gameStartTime = Double(time)
        }
        else {
            gameDataModel.gameStartTime = 0
        }
        print(gameDataModel.gameStartTime)
    }
    
    //MARK: - UIUpdate Function
    
    func updateUIUser(){
        nameOfSummoner.text = String(userDataModel.name)
    }
    
    @objc func updateUIStatus() {
        if gameDataModel.gameStartTime > 0 {
            gameStatus.text = IN_GAME_STATUS
        }
        else {
            gameStatus.text = OUT_OF_GAME_STATUS
            gameLenghtTimerLabel.text = "0"
        }
    }
    
    func updateUIView() {
        self.view.addSubview(infoGameView)
        infoGameView.center = self.view.center
        infoGameView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        infoGameView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.infoGameView.alpha = 1
            self.infoGameView.transform = CGAffineTransform.identity
        }
    }
    
    //MARK: - IBActions
    
    @IBAction func changeRegion(_ sender: Any) {
        changeRegion.show()
    }
    
    @IBAction func searchButton(_ sender: Any) {
        if let regionName = changeRegion.selectedItem {
            if let realRegionName = dict[regionName] {
                if let name = searchingNameOfSummoner.text {
                    checkLolName(region: realRegionName, summName: name)
                    updataImage()
                    let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(execute), userInfo: nil, repeats: true)
                    timer.fire()
                    updateUIView()
                }
            }
        }
    }
    
    @objc func execute() {
        if let regionName = changeRegion.selectedItem {
            if let realRegionName = dict[regionName] {
        checkLolStatus(region: realRegionName, summId: userDataModel.id)
            }
        }
    }
    
    func updataImage() {
        imageURL = URLProvider.avatarImage(withProfileIconId: userDataModel.profileIconId)
        if let url = URL(string: imageURL){
            if let data = NSData(contentsOf: url) {
                imageOfSummoner.image = UIImage(data: data as Data)
            }
        }
    }
}

//MARK: - TextField Delegate

extension StartViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchingNameOfSummoner.resignFirstResponder()
        return true
    }
}

