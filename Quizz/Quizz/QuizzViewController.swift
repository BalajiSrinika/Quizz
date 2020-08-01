//
//  QuizzViewController.swift
//  Quizz
//
//  Created by Balaji Pandian on 31/07/20.
//  Copyright © 2020 Balaji Pandian. All rights reserved.
//

import UIKit

class QuizzViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    var quizzViewModel : QuizzViewModel!
    var receivedQuestions = [Result]()
    var selectedAnswer = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Initilize ViewModel
        self.quizzViewModel = QuizzViewModel()
        self.quizzViewModel.vc = self
        setDefaults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    /// Set Defaults value
    fileprivate func setDefaults(){
        setTitle()
        quizzViewModel.receivedModel = receivedQuestions
        quizzViewModel.setAllAnswer()
        quizzViewModel.StartedTime = Date()
    }
    
    func setTitle(){
        self.title = "Question:\(quizzViewModel.questIndex + 1)"
    }
    
}

extension QuizzViewController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.quizzViewModel.receivedModel[self.quizzViewModel.questIndex].incorrectAnswers.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "CategorySectionCell") as! CategorySectionCell
        headerCell.questionLbl.text = self.quizzViewModel.receivedModel[self.quizzViewModel.questIndex].question
        return headerCell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizzCell") as! QuizzCell
        let options = self.quizzViewModel.receivedModel[self.quizzViewModel.questIndex].incorrectAnswers[indexPath.row]
        cell.optionsLbl.text = options
        cell.tag = indexPath.row
        
        if self.quizzViewModel.receivedModel[self.quizzViewModel.questIndex].selectedIndex == indexPath.row{
            cell.optionsimg.image = UIImage(named: "on")
        }else{
            cell.optionsimg.image = UIImage(named: "off")
        }
        cell.bgView.backgroundColor = .white
        
        if let isAnswered = self.quizzViewModel.receivedModel[self.quizzViewModel.questIndex].isCorrect{
            if self.quizzViewModel.receivedModel[self.quizzViewModel.questIndex].correctAnswer == options{
                //Set Green Color
                cell.bgView.backgroundColor = UIColor.green.withAlphaComponent(0.7)
            }
            else if self.quizzViewModel.receivedModel[self.quizzViewModel.questIndex].selectedIndex == indexPath.row{
                cell.bgView.backgroundColor = UIColor.red.withAlphaComponent(0.7)
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if  self.quizzViewModel.receivedModel[self.quizzViewModel.questIndex].selectedIndex == -1{
            let selctedAnswer = self.quizzViewModel.receivedModel[self.quizzViewModel.questIndex].incorrectAnswers[indexPath.row]
            let correctAnswer = self.quizzViewModel.receivedModel[self.quizzViewModel.questIndex].correctAnswer
            
            self.quizzViewModel.receivedModel[self.quizzViewModel.questIndex].selectedIndex = indexPath.row
            
            self.quizzViewModel.receivedModel[self.quizzViewModel.questIndex].selectedAnswer = selctedAnswer
            
            self.quizzViewModel.receivedModel[self.quizzViewModel.questIndex].isCorrect = getCorrectAnswer(selectedAnswer: selctedAnswer, correctAnswer: correctAnswer)
            self.tableview.reloadData()
        }
    }
    
    func getCorrectAnswer(selectedAnswer:String,correctAnswer:String) -> Bool{
        if selectedAnswer == correctAnswer{
            return true
        }
        
        return false
    }
    
    @IBAction func NextQuest(_ sender: UIButton){
        
        if  self.quizzViewModel.receivedModel[self.quizzViewModel.questIndex].selectedIndex == -1{
            
            let alertView = UIAlertController.init(title: "Alert!", message: "Please select answer and proceed", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
            let okAction    = UIAlertAction.init(title: "Ok", style: .default, handler: nil)
            
            alertView.addAction(cancelAction)
            alertView.addAction(okAction)
            
            self.present(alertView, animated: true, completion: nil)
        }
        else{
            self.quizzViewModel.questIndex += 1
            if self.quizzViewModel.questIndex == 10{
                //Display the alert
                // navigate to Result page
                quizzViewModel.showSimpleAlert()
                return
            }
            self.tableview.reloadData()
            self.setTitle()
        }
        
    }
    
    
    
}

class QuizzCell: UITableViewCell {
    
    @IBOutlet weak var optionsLbl:UILabel!
    @IBOutlet weak var optionsimg:UIImageView!
    @IBOutlet weak var bgView: UIView!
}


class CategorySectionCell: UITableViewCell {
    @IBOutlet weak var questionLbl:UILabel!
}
