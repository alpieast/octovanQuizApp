//
//  ViewController.swift
//  AlomaFire
//
//  Created by Alperen Dogu on 22.06.2018.
//  Copyright © 2018 Alperen Dogu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase
import FirebaseDatabase
import CoreData
import FirebaseFirestore

class ViewController: UIViewController,UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    let referanceURL:String = "https://quizapp-alpi.firebaseio.com/"
    var ref: DatabaseReference! = Database.database().reference()
    let baseUrl = "https://private-anon-2a496da62c-quizmasters.apiary-mock.com/questions"
    var questString: [String] = []
    var answerString: [String] = []
    var onlyAnswer: [[String]] = []
    var onlyBool: [[Bool]] = []
    var choiceOne: Bool = false
    var choiceTwo: Bool = false
    var choiceThree: Bool = false
    var choiceFour: Bool = false
    var userName = String()
    
    var trueFalse: Bool = false
    var i = 0
    var choiceNumOne = 0
    var choiceNumTwo = 0
    var totalPoint = 0
    var choiceStatue: Bool = false
    var timerValue: Float = 0.0
    var resultTrueFalse: [String] = []
    var resultBoolCount = 0
    var timerStop: Bool = false
    var alpiTimer: Timer!
    @IBOutlet weak var timerView: UIProgressView!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblQuestionNum: UILabel!
    @IBOutlet weak var lblTotalPt: UILabel!
    @IBOutlet weak var viewResult: UIView!
    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var btnAnswer1: UIButton!
    @IBOutlet weak var btnAnswer2: UIButton!
    @IBOutlet weak var btnAnswer3: UIButton!
    @IBOutlet weak var btnAnswer4: UIButton!
    @IBOutlet weak var answerCollection: UICollectionView!
    
    @IBAction func btnAnswer1(_ sender: UIButton) {
        btnEnableFalse()
        answerChecker()
        changerForChoicesAndQuestion()
    }
    @IBAction func btnAnswer2(_ sender: UIButton) {
        btnEnableFalse()
        answerChecker()
        changerForChoicesAndQuestion()
    }
    @IBAction func btnAnswer3(_ sender: UIButton) {
        btnEnableFalse()
        answerChecker()
        changerForChoicesAndQuestion()
    }
    @IBAction func btnAnswer4(_ sender: UIButton) {
        btnEnableFalse()
        answerChecker()
        changerForChoicesAndQuestion()
     }
    //Functions Start
    func btnEnableFalse(){
        self.btnAnswer1.isEnabled = false
        self.btnAnswer2.isEnabled = false
        self.btnAnswer3.isEnabled = false
        self.btnAnswer4.isEnabled = false
    }
    func changerForChoicesAndQuestion() {
        if (self.i < questString.count) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
        self.btnAnswer1.backgroundColor = UIColor.white
        self.btnAnswer2.backgroundColor = UIColor.white
        self.btnAnswer3.backgroundColor = UIColor.white
        self.btnAnswer4.backgroundColor = UIColor.white
        self.btnAnswer1.isEnabled = true
        self.btnAnswer2.isEnabled = true
        self.btnAnswer3.isEnabled = true
        self.btnAnswer4.isEnabled = true
        self.lblQuestion.text = self.questString[self.i]
        self.i += 1
        self.lblQuestionNum.text = "Question: \(self.i)"
        self.btnAnswer1.setTitle(self.onlyAnswer[self.choiceNumOne][self.choiceNumTwo],for: .normal)
        self.choiceOne = self.onlyBool[self.choiceNumOne][self.choiceNumTwo]
        self.choiceNumTwo += 1
        self.btnAnswer2.setTitle(self.onlyAnswer[self.choiceNumOne][self.choiceNumTwo], for: .normal)
        self.choiceTwo = self.onlyBool[self.choiceNumOne][self.choiceNumTwo]
        self.choiceNumTwo += 1
        self.btnAnswer3.setTitle(self.onlyAnswer[self.choiceNumOne][self.choiceNumTwo], for: .normal)
        self.choiceThree = self.onlyBool[self.choiceNumOne][self.choiceNumTwo]
        self.choiceNumTwo += 1
        self.btnAnswer4.setTitle(self.onlyAnswer[self.choiceNumOne][self.choiceNumTwo], for: .normal)
        self.choiceFour = self.onlyBool[self.choiceNumOne][self.choiceNumTwo]
        self.choiceNumTwo -= 3
        self.choiceNumOne += 1
        self.lblTotalPt.text = "Total Point is: \(self.totalPoint)"
        self.timerValue = 0})
        }else if(self.i == questString.count ){
            btnEnableFalse()
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.viewResult.alpha = 1
                self.answerCollection.reloadData()
                self.alpiTimer.invalidate()
                self.dataBaseBam()
            })
            self.lblResult.text = "Total Point is: \(totalPoint)"
            self.nameLabel.text = "Congratulations \(userName)"
        }
        }
    @objc func updateProgress(){
        if (self.timerStop == false){
        timerValue += 0.001
        timerView.progress = timerValue
        }
        
        if  timerValue >= 1 {
            timerValue = 0
            print(timerValue)
            if self.choiceOne == true {
                self.btnAnswer1.backgroundColor = UIColor.green
            }else if self.choiceTwo == true{
                self.btnAnswer2.backgroundColor = UIColor.green
            }else if self.choiceThree == true{
                self.btnAnswer3.backgroundColor = UIColor.green
            }else if self.choiceFour == true {
                self.btnAnswer4.backgroundColor = UIColor.green
            }
            if (self.i < questString.count) {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    self.resultTrueFalse.append("notAnswered")
                    self.btnEnableFalse()
                    self.changerForChoicesAndQuestion()})
            }else if(self.i == questString.count ){
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    self.resultTrueFalse.append("notAnswered")
                    self.answerCollection.reloadData()
                    self.viewResult.alpha = 1
                    self.timerStop = true
                    self.dataBaseBam()
                    self.btnEnableFalse()
                    
                })
                self.lblResult.text = "Total Point is: \(totalPoint)"
                self.nameLabel.text = "Congratulations \(userName)"
                }
            }
        }
    func answerChecker() {
        if btnAnswer1.isTouchInside {
            if self.choiceOne{
                self.totalPoint += 10
                self.btnAnswer1.backgroundColor = UIColor.green
                self.resultTrueFalse.append("true")
            } else {
                self.btnAnswer1.backgroundColor = UIColor.red
                self.resultTrueFalse.append("false")
            }
            if self.choiceTwo{
                self.btnAnswer2.backgroundColor = UIColor.green
            }
            if self.choiceThree{
                self.btnAnswer3.backgroundColor = UIColor.green
            }
            if self.choiceFour{
                self.btnAnswer4.backgroundColor = UIColor.green
            }
        }
        if btnAnswer2.isTouchInside {
            if self.choiceTwo{
                self.totalPoint += 10
                self.btnAnswer2.backgroundColor = UIColor.green
                self.resultTrueFalse.append("true")
            } else {
                self.btnAnswer2.backgroundColor = UIColor.red
                self.resultTrueFalse.append("false")
            }
            if self.choiceOne{
                self.btnAnswer1.backgroundColor = UIColor.green
            }
            if self.choiceThree{
                self.btnAnswer3.backgroundColor = UIColor.green
            }
            if self.choiceFour{
                self.btnAnswer4.backgroundColor = UIColor.green
            }
        }
        if btnAnswer3.isTouchInside {
            if self.choiceThree{
                self.totalPoint += 10
                self.btnAnswer3.backgroundColor = UIColor.green
                self.resultTrueFalse.append("true")
            } else {
                self.btnAnswer3.backgroundColor = UIColor.red
                self.resultTrueFalse.append("false")
            }
            if self.choiceOne{
                self.btnAnswer1.backgroundColor = UIColor.green
            } else if self.choiceTwo{
                self.btnAnswer2.backgroundColor = UIColor.green
            } else if self.choiceFour{
                self.btnAnswer4.backgroundColor = UIColor.green
            }
        }
        if btnAnswer4.isTouchInside {
            if self.choiceFour{
                self.totalPoint += 10
                self.btnAnswer4.backgroundColor = UIColor.green
                self.resultTrueFalse.append("true")
            } else {
                self.btnAnswer4.backgroundColor = UIColor.red
                self.resultTrueFalse.append("false")
            }
            if self.choiceOne{
                self.btnAnswer1.backgroundColor = UIColor.green
            } else if self.choiceTwo{
                self.btnAnswer2.backgroundColor = UIColor.green
            } else if self.choiceThree{
                self.btnAnswer3.backgroundColor = UIColor.green
            }
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.questString.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "answerCollectionCell", for: indexPath)
        if (self.resultTrueFalse[self.resultBoolCount] == "true") {
            cell.backgroundColor = UIColor.green
            self.resultBoolCount += 1
        }else if(self.resultTrueFalse[self.resultBoolCount] == "false"){
            cell.backgroundColor = UIColor.red
            self.resultBoolCount += 1
        }else {
            cell.backgroundColor = UIColor.blue
            self.resultBoolCount += 1
        }
        return cell
    }
    func dataBaseBam(){
        let referanceDB = Database.database().reference(fromURL: referanceURL)
        
        let value3 = ["userName": userName, "totalPoint":totalPoint] as [String : Any]
        var value4 = [userName,totalPoint] as [Any]
        
        //referanceDB.child("results").childByAutoId().setValue(value3)
        //ref?.child("userResults").childByAutoId().setValue(value3)
        
        ref?.child("userResults").childByAutoId().setValue(userName)
        ref?.child("userPoints").childByAutoId().setValue(totalPoint)
        
        
 }
    func getJSONData(url: String) {
        Alamofire.request(url, method: .get).responseJSON { response in
            if response.result.isSuccess {
                let jsonData : JSON = JSON(response.result.value!)
                //print(jsonData)
                for json in jsonData.arrayValue{
                    //print("\(json["question"])")
                    //print("\(json["choices"])")
                    //print(json["choices"]["choice"])
                    //print(json["choice"])
                    self.questString.insert("\(json["question"])", at: 0)
                    self.answerString.insert("\(json["choices"])", at: 0)
                    self.onlyAnswer.insert(json["choices"].arrayValue.map({$0["choice"].stringValue}), at: 0)
                    self.onlyBool.insert(json["choices"].arrayValue.map({$0["correct"].boolValue}), at: 0)
                };
                self.changerForChoicesAndQuestion()
            } else {
                print("Error: \(String(describing: response.result.error))")
            }
        }
    }
    
    //Functions End
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnEnableFalse()
        getJSONData(url: baseUrl)
        userName = name
        answerCollection.delegate = self
        answerCollection.dataSource = self
        self.alpiTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

