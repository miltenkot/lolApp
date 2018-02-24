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
import SwiftyJSON

class StartViewController: UIViewController {
    
    @IBOutlet weak var imageOfSummoner: UIImageView!
    
    @IBOutlet weak var searchingNameOfSummoner: UITextField!
    @IBOutlet weak var nameOfSummoner: UILabel!
    @IBOutlet weak var gameStatus: UILabel!
    
    var imageURL = ""
    var APIURL_Spect = ""
    //https://eun1.api.riotgames.com/lol/spectator/v3/active-games/by-summoner/{summid}}"
    var APIURL_Summ = ""
    //https://eun1.api.riotgames.com/lol/summoner/v3/summoners/by-name/{nickname}}"
    let params : [String : String] = ["api_key" : "RGAPI-3ca170df-21f6-4537-a311-f7dddb4f0ea2"]
    let gameDataModel = GameDataModel()
    let userDataModel = UserDataModel()
    
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
        
        changeRegion.dataSource = ["eun1","euw1","na1"]
        
        changeRegion.selectionAction = { [weak self]
            index, item in
            self?.regionButton.setTitle(item, for: .normal)
            
            
        }
        
    }
    func checkLolName(region:String, summName: String){
        
        APIURL_Summ = "https://\(region).api.riotgames.com/lol/summoner/v3/summoners/by-name/\(summName)"
        getLolInfoUser(url: APIURL_Summ, parameters: params)
        
    }
    func checkLolStatus(region: String,summId: Int){
        APIURL_Spect = "https://\(region).api.riotgames.com/lol/spectator/v3/active-games/by-summoner/\(summId)"
        getLolInfo(url: APIURL_Spect, parameters: params)
    }
    
    
    func getLolInfoUser(url: String,parameters: [String : String]){
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess{
                let lolJSON : JSON = JSON(response.result.value!)
                
                self.updateGameUser(json: lolJSON)
                self.updateUIUser()
                print(response)
                
                
            }
            else {
                print(response.result.error!)
            }
            
        }
        
    }
    func getLolInfo(url: String,parameters: [String : String]){
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess{
                
                print(response)
                let lolJSON : JSON = JSON(response.result.value!)
                self.updateGameStatus(json: lolJSON)
                self.updateUIStatus()
                
            }
            else {
                print(response.result.error!)
            }
            
        }
        
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
    @IBAction func searchButton(_ sender: UIBarButtonItem) {
        clearUI()
        if let regionName = changeRegion.selectedItem{
            if let name = searchingNameOfSummoner.text{
                
                
                checkLolName(region: regionName, summName: name)

                
            }
        }
        let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(execute), userInfo: nil, repeats: true)
        timer.fire()
        
    }
    
    
    
    func clearUI(){
        
        nameOfSummoner.text = ""
        gameStatus.text = ""
        
    }
    @objc func execute(){
        if let regionName = changeRegion.selectedItem{
        checkLolStatus(region: regionName, summId: userDataModel.id)
            updataImage()
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
