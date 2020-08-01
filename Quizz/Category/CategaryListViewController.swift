//
//  CategaryListViewController.swift
//  Quizz
//
//  Created by Balaji Pandian on 31/07/20.
//  Copyright © 2020 Balaji Pandian. All rights reserved.
//

import UIKit

class CategaryListViewController: UITableViewController {
    
    
    var categoryViewModelObj : CategoryViewModel!
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Initilize ViewModel
        categoryViewModelObj = CategoryViewModel()
        categoryViewModelObj.vc = self
        self.setDefaults()
    }
    
    
    /// Get Quiz List from server
    fileprivate func getQuizList(){
        activityIndicator.startAnimating()
        self.categoryViewModelObj.requestAPI{ (questionList) in
            print(questionList)
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    /// Set defaults values
    fileprivate func setDefaults(){
        self.title = "Quiz"
        self.tableView.tableFooterView = UIView()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = true
        activityIndicator = .init(style: .large)
        activityIndicator.center = view.center
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        getQuizList()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.categoryViewModelObj.Category.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
        
        cell.categoryLbl.text = self.categoryViewModelObj.Category[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "QuizzViewController") as! QuizzViewController
        let filterQuestions = categoryViewModelObj.listQuizzQuestions.filter{
            $0.category.rawValue ==  self.categoryViewModelObj.Category[indexPath.row]
        }
        nextViewController.receivedQuestions = filterQuestions
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    
}


class CategoryCell: UITableViewCell {
    @IBOutlet weak var categoryLbl : UILabel!
}


