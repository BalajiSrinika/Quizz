//
//  QuizzViewModel.swift
//  Quizz
//
//  Created by Balaji Pandian on 31/07/20.
//  Copyright © 2020 Balaji Pandian. All rights reserved.
//

import Foundation
import UIKit


class QuizzViewModel {
    
   weak var vc : QuizzViewController!
    
    var receivedModel = [Result]()
    var correctAnswers = [Bool]()
    var questIndex = Int()
    
    var StartedTime = Date()
    
    func setAllAnswer(){
        
        print("StartedTime:\(StartedTime)")
        
        for (index,obj) in receivedModel.enumerated(){
            let correctAns = obj.correctAnswer
            var options = obj.incorrectAnswers
            options.append(correctAns)
            let shuffleOptions = options.shuffled()
            receivedModel[index].incorrectAnswers = shuffleOptions
        }
    }
    

    
    func showSimpleAlert() {
        let correctAnswer = self.receivedModel.filter{
            $0.isCorrect == true
        }
        
        let actualTimeTaken = getMinutesDifferenceFromTwoDates(start: StartedTime, end: Date())
        
        let alert = UIAlertController(title: "Finished!", message: "You Score is \(correctAnswer.count ) / 10  \n\n Actual Time Taken: \(actualTimeTaken) sec ",         preferredStyle: UIAlertController.Style.alert)
        
        
        alert.addAction(UIAlertAction(title: "View Results",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ViewResultsViewController") as! ViewResultsViewController
                                        
                                        nextViewController.quizzResults = self.receivedModel
                                        nextViewController.score = correctAnswer.count
                                        nextViewController.timetaken = actualTimeTaken
                                        self.vc.navigationController?.pushViewController(nextViewController, animated: true)
                                        
                                        
        }))
        vc.present(alert, animated: true, completion: nil)
    }
    
    func getSec()-> Int{
       let date = Date()
        let calendar = Calendar.current
        let seconds = calendar.component(.second, from: date)
        return seconds
    }
    
    func getMinutesDifferenceFromTwoDates(start: Date, end: Date) -> Int
    {

        let diff = Int(end.timeIntervalSince1970 - start.timeIntervalSince1970)

        let hours = diff / 3600
        let minutes = (diff - hours * 3600) / 60
        let seconds = diff
        return seconds
    }
    
    
}
