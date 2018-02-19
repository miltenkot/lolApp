//
//  ViewController.swift
//  lolApp
//
//  Created by Bartek Lanczyk on 15.02.2018.
//  Copyright © 2018 miltenkot. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    
    @IBOutlet weak var gameStatus: UILabel!
    
    let APIURL = "https://euw1.api.riotgames.com/lol/spectator/v3/active-games/by-summoner/67387443?api_key=RGAPI-1ffa2c56-5b68-45b4-966f-d61856039a9f"
    
    let gameDataModel = GameDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getLolInfo(url: APIURL)
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getLolInfo(url: String){
        Alamofire.request(APIURL).responseJSON {
            response in
            if response.result.isSuccess{
            //self.parse(jsonData: response.data!)
                let lolJSON : JSON = JSON(response.result.value!)
                self.updateGameStatus(json: lolJSON)
                self.updateUI()
            }
            else {
                print(response.result.error!)
            }
            
        }
        
    }
    
    func updateGameStatus(json: JSON){
        if let time = json["gameStartTime"].double{
        gameDataModel.gameStartTime = Int(time)
    }
        else {
            gameStatus.text = "SMOKE"
        }
    }
    
    func updateUI(){
        if gameDataModel.gameStartTime > 0{
            gameStatus.text = "IN GAME"
        }
        else {
            gameStatus.text = "SMOKE"
        }
    }
    
//    func parse(jsonData : Data){
//        do
//        {
//           try print(JSON(data: jsonData))
//        }
//        catch{
//            print(error)
//        }
//
//    }
    

    


}

