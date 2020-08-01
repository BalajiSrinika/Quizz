//
//  ViewResultsViewController.swift
//  Quizz
//
//  Created by Balaji Pandian on 31/07/20.
//  Copyright © 2020 Balaji Pandian. All rights reserved.
//

import UIKit

class ViewResultsViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var timeLbl:UILabel!{
        didSet{
            timeLbl.layer.cornerRadius = 20
        }
    }
     @IBOutlet weak var scoreLbl:UILabel!{
         didSet{
             scoreLbl.layer.cornerRadius = 20
         }
     }
     @IBOutlet weak var wrongLbl:UILabel!{
         didSet{
             wrongLbl.layer.cornerRadius = 20
         }
     }
    
    var quizzResults = [Result]()
    var timetaken = Int()
    var score = Int()
    var wrongAnswers = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
          
        self.navigationItem.hidesBackButton = true
        self.title = "Results"
        
        timeLbl.text = "\(timetaken) sec"
        scoreLbl.text = "\(score)"
        wrongLbl.text = "\(10 - score)"
        

        // Do any additional setup after loading the view.
    }
}

extension ViewResultsViewController : UITableViewDataSource , UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.quizzResults.count
    }
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.quizzResults[section].incorrectAnswers.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "CategorySectionCell") as! CategorySectionCell
        headerCell.questionLbl.text = self.quizzResults[section].question
        return headerCell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizzCell") as! QuizzCell
        let options =  self.quizzResults[indexPath.section].incorrectAnswers[indexPath.row]
        
        cell.optionsLbl.text = options
        cell.tag = indexPath.row
        cell.bgView.backgroundColor = .white
        if let isAnswered = self.quizzResults[indexPath.section].isCorrect{
            if self.quizzResults[indexPath.section].correctAnswer == options{
                //Set Green Color
                cell.bgView.backgroundColor = UIColor.green.withAlphaComponent(0.7)
            }
            else if self.quizzResults[indexPath.section].selectedIndex == indexPath.row{
                cell.bgView.backgroundColor = UIColor.red.withAlphaComponent(0.7)
            }
            
        }
        
        return cell
        
    }
    
    
    
}
