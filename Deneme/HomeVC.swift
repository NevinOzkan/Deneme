//
//  HomeVC.swift
//  Deneme
//
//  Created by Nevin Özkan on 27.02.2025.
//

import UIKit

class HomeVC: UIViewController {
    let textGenerator = TextGenerator()
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func button(_ sender: Any) {
        textGenerator.generateStory { story in
            DispatchQueue.main.async {
                if let story = story {
                    self.textView.text = story
                } else {
                    self.textView.text = "Masal oluşturulamadı."
                }
            }
        }
    }
    
}


