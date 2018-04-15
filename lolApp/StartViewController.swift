//
//  StartViewController.swift
//  lolApp
//
//  Created by Bartek Lanczyk on 20.02.2018.
//  Copyright © 2018 miltenkot. All rights reserved.
//

import UIKit
import DropDown
import Alamofire
import Alamofire_Synchronous
import SwiftyJSON

class StartViewController: UIViewController {
    
    
    @IBOutlet var infoGameView: UIView!
    @IBOutlet weak var imageOfSummoner: UIImageView!
    
    @IBOutlet weak var searchingNameOfSummoner: UITextField!
    @IBOutlet weak var nameOfSummoner: UILabel!
    @IBOutlet weak var gameStatus: UILabel!
    var imageURL = ""
    var APIURL_Spect = ""
    //https://eun1.api.riotgames.com/lol/spectator/v3/active-games/by-summoner/{summid}}"
    var APIURL_Summ = ""
    //https://eun1.api.riotgames.com/lol/summoner/v3/summoners/by-name/{nickname}}"
    let params : [String : String] = ["api_key" : "RGAPI-b5365708-d001-44d1-bdce-8f490de3f3da"]
    let gameDataModel = GameDataModel()
    let userDataModel = UserDataModel()
    let dict = ["RU" : "ru", "BR" : "br1","KR" : "kr","OC" : "oc1","JAPAN" : "jp1","NA": "na1","EUEN": "eun1","EUW" : "euw1","LA1": "la1","LA2": "la2"]
    //MARK: - DropDown Menu
    @IBOutlet weak var regionButton: UIButton!
    
    let changeRegion = DropDown()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupDropDowns()
       
    
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Actions
    
    @IBAction func changeRegion(_ sender: Any) {
        changeRegion.show()
    }
    
    //MARK: Setup
    
    func setupDropDowns(){
        setupChangeRegion()
    }
    
    func setupChangeRegion(){
        changeRegion.anchorView = regionButton
      
        changeRegion.dataSource = Array(dict.keys)
        
        
        changeRegion.selectionAction = { [weak self]
            index, item in
            self?.regionButton.setTitle(item, for: .normal)
            
            
        }
        
        
    }
    func checkLolName(region:String, summName: String){
        
        APIURL_Summ = "https://\(region).api.riotgames.com/lol/summoner/v3/summoners/by-name/\(summName)"
        print(APIURL_Summ)
        getLolInfoUser(url: APIURL_Summ, parameters: params)
        
    }
    func checkLolStatus(region: String,summId: Int){
        APIURL_Spect = "https://\(region).api.riotgames.com/lol/spectator/v3/active-games/by-summoner/\(summId)"
        print(APIURL_Spect)
        getLolInfo(url: APIURL_Spect, parameters: params)
    }
    
    
    func getLolInfoUser(url: String,parameters: [String : String]){
        let response = Alamofire.request(url, parameters: parameters).responseJSON()
        let json : JSON  = JSON(response.result.value!)
        self.updateGameUser(json: json )
        self.updateUIUser()
        
    }
    
    func getLolInfo(url: String,parameters: [String : String]){
        let response = Alamofire.request(url,parameters: parameters).responseJSON()
        let json : JSON  = JSON(response.result.value!)
        self.updateGameStatus(json: json )
        self.updateUIStatus()
        
    }
    
    func updateGameUser(json: JSON){
        if let summ = json["name"].string{
            userDataModel.name = summ
            userDataModel.profileIconId = json["profileIconId"].intValue
            userDataModel.id = json["id"].intValue
        }
        else {
            userDataModel.name = "motherfucker"
            userDataModel.profileIconId = 0
            userDataModel.id = 0
        }
        print(userDataModel.name)
        print(userDataModel.id)
        
        
        
        
    }
    func updateGameStatus(json: JSON){
        if let time = json["gameStartTime"].double{
            gameDataModel.gameStartTime = Double(time)
        }
        else {
            gameDataModel.gameStartTime = 0
        }
        print(gameDataModel.gameStartTime)
    }
    
    func updateUIUser(){
        nameOfSummoner.text = String(userDataModel.name)
        
        
        
        
    }
    func updateUIStatus(){
        if gameDataModel.gameStartTime > 0{
            gameStatus.text = "IN GAME"
        }
        else {
            gameStatus.text = "Smoke"
        }
        
    }
    func updateUIView(){
        self.view.addSubview(infoGameView)
        infoGameView.center = self.view.center
        infoGameView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        infoGameView.alpha = 0
        UIView.animate(withDuration: 0.4){
            self.infoGameView.alpha = 1
            self.infoGameView.transform = CGAffineTransform.identity
        }
    }
    
    @IBAction func searchButton(_ sender: Any) {
        
        if let regionName = changeRegion.selectedItem{
            
            if let realRegionName = dict[regionName]{
                
                if let name = searchingNameOfSummoner.text{
                    
                    
                    checkLolName(region: realRegionName, summName: name)
                    execute()
                    updateUIView()
                    
                }
            }
        }
        // let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(execute), userInfo: nil, repeats: true)
        //timer.fire()
        
    }
    
    

    @objc func execute(){
        if let regionName = changeRegion.selectedItem{
            if let realRegionName = dict[regionName]{
        checkLolStatus(region: realRegionName, summId: userDataModel.id)
            updataImage()
            }
        }
    }
    func updataImage(){
        imageURL = "http://ddragon.leagueoflegends.com/cdn/6.24.1/img/profileicon/\(userDataModel.profileIconId).png"
        if let url = URL(string: imageURL){
            if let data = NSData(contentsOf: url){
                imageOfSummoner.image = UIImage(data: data as Data)
            }
        }
    }
    
}

