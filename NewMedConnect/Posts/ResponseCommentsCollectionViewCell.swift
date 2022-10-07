//
//  ResponseCommentsCollectionViewCell.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 8/23/22.
//

import UIKit

var selectedTextFieldCount3 = 0

class ResponseCommentsCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var responseReplyLabel: UILabel!
    
    @IBOutlet weak var responseUserLabel: UILabel!

    @IBOutlet weak var responseDateLabel: UILabel!
    
    @IBOutlet weak var responseUpvoteLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    
    @IBOutlet weak var voteContentView: UIView!
    
    @IBOutlet weak var upheartView: UIView!
    
    @IBOutlet weak var downheartView: UIView!
    
    @IBOutlet weak var upheartButton: UIButton!
    
    @IBOutlet weak var downheartButton: UIButton!
    
    @IBOutlet weak var upheartImage: UIImageView!
    
    @IBOutlet weak var downheartImage: UIImageView!
    
    @IBOutlet weak var pieChartButton: UIButton!
    
    
    
    @IBOutlet weak var deleteOrFlag: UIButton!
    
    @IBOutlet weak var postCommentReplyView: UIView!
    
    @IBOutlet weak var postCommentReplyLabel: UILabel!
    
    @IBOutlet weak var postCommentReplyTextField: UITextField!
    
    @IBOutlet weak var postCommentReplyCancelorPost: UIButton!
    
    @IBOutlet weak var postCommentReplyViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var postCommentReplyUpperConstraint: NSLayoutConstraint!
    
    weak var viewController: UIViewController?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
 
        //        replyTextField.delegate = self
        postCommentReplyTextField.delegate = self
        
    }
    
    @objc func presentPieChart() {
        
    }
    
    @objc func presentError() {
        let alert = UIAlertController(title: "Error⚠️❌", message: "Please Connect to WiFi or Restart App", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
                case .default:
                print("default")

                
                case .cancel:
                print("cancel")
                
                case .destructive:
                print("destructive")
                
            }
        }))
        
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
//        self.viewController?.present(alert, animated: true, completion: nil)
    }
    
    @objc func presentReport() {
        
       
    }
    
    @objc func presentSuccess() {
        let alert = UIAlertController(title: "Success‼️✅", message: "Please Refresh", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
                case .default:
                print("default")

                
                case .cancel:
                print("cancel")
                
                case .destructive:
                print("destructive")
                
            }
        }))
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)

//        self.viewController?.present(alert, animated: true, completion: nil)
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("TEst")
//        selectedTextFieldCount = textField.tag + 1
//
//        selectedTextFieldCount3 =
//
//        selectedTextFieldCount2 = sharedComments.map({$0.commentReplies})[textField.tag].count
//
//        whichTextField = "commentReply"

        
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text!.count > 0 {
            postCommentReplyCancelorPost.setTitle("Post", for: .normal)
        }
        else {
            postCommentReplyCancelorPost.setTitle("Cancel", for: .normal)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        replyTextFieldVal2 = textField.text!
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
