//
//  ViewController.swift
//  StepCounter
//
//  Created by suhemparashar on 05/06/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var stepCountLabel: UILabel!
    
    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.authorizeHealthKit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.authorizeHealthKit()
    }
    
    @IBAction func refreshButtonClicked(_ sender: Any) {
        viewModel.authorizeHealthKit()
    }
    
}

extension ViewController: Delegate {
    func stepCountFetched(stepCount: Int) {
        DispatchQueue.main.async {
            self.stepCountLabel.text = "\(stepCount)"
        }
    }
}


