//
//  DiscussionCommentsCollectionViewCell.swift
//  NewMedConnect
//
//  Created by Eshaan Sharma on 7/8/22.
//

import UIKit

var x = 3

class DiscussionCommentsCollectionViewCell: UICollectionViewCell {
    
    
    
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var upHeartLabel: UILabel!
    
    @IBOutlet weak var downHeartLabel: UILabel!
    
    @IBOutlet weak var upHeartButton: UIButton!
    
    @IBOutlet weak var downHeartButton: UIButton!
    
    @IBOutlet weak var upHeartImage: UIImageView!
    
    @IBOutlet weak var downHeartImage: UIImageView!
    
    @IBOutlet weak var upHeartView: UIView!
    
    @IBOutlet weak var downHeartView: UIView!
    
    @IBOutlet weak var commentCountLabel: UILabel!
    
    @IBOutlet weak var commentDateLabel: UILabel!
    
    @IBOutlet weak var corneredView: UIView!
    
    @IBOutlet weak var repliesButton: UIButton!
    
    @IBOutlet weak var cellUsername: UILabel!
    
    @IBOutlet weak var responseCommentsViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var responseCommentsView: UIView!
    
    
    @IBOutlet weak var responseCommentsCollectionView: UICollectionView!
    
    
    var discussions: DiscussionComment? {
        didSet {
            commentLabel.text = discussions?.discussionsCommentTitle
            responseCommentsCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        responseCommentsCollectionView.delegate = self
        responseCommentsCollectionView.dataSource = self
        
    }

   
}
var test = [[1,2,3], [1,2,3,4], [1,2,3,4,5]]

var i = -1

var displayedReplies = 0
var tempI = 0

    
extension DiscussionCommentsCollectionViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 300, height: 105)
    
        }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(sharedComments)
        if i == sharedComments.count - 1 {
            i = -1
        }
        i += 1
        print(i)
        print(sharedComments.map({$0.commentReplies})[i].count)
        print(sharedComments.map({$0.commentReplies})[i])
          collectionView.tag = i

        return sharedComments.map({$0.commentReplies})[i].count
        
//        print(sharedComments)
//        if i == sharedComments.count - 1 {
//            i = -1
//        }
//        i += 1
//        print(i)
//        print(test[i].count)
//        print(test[i])
//        collectionView.tag = i
//        return test[i].count
    }
     
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "responseCommentsCollectionCell", for: indexPath) as? ResponseCommentsCollectionViewCell
        
        print(sharedComments.map({$0.commentReplies})[collectionView.tag])
        print(sharedComments.map({$0.commentReplies})[collectionView.tag].map({$0.discussionCommentReplyTitle}))
        print(sharedComments.map({$0.commentReplies})[collectionView.tag].map({$0.discussionCommentReplyTitle})[indexPath.row])
        cell?.responseReplyLabel.text = sharedComments.map({$0.commentReplies})[collectionView.tag].map({$0.discussionCommentReplyTitle})[indexPath.row]
        
        //cell?.responseReplyLabel.text = String(test[collectionView.tag][indexPath.row])
        
            
        return cell!
        
    }
}

    
    
//    func setCollectionViewDelegate<D: UICollectionViewDelegate & UICollectionViewDataSource>(delegate: D, forRow row:Int) {
//        responseCommentsCollectionView.delegate = delegate
//        responseCommentsCollectionView.dataSource = delegate
//        responseCommentsCollectionView.tag = row
//        responseCommentsCollectionView.reloadData()
//    }
    


//extension DiscussionCommentsCollectionViewCell:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
//    
//    
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 300, height: 105)
//
//    }
//func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
////    if collectionView.tag == 0 {
////        return 1
////    } else if collectionView.tag == 1 {
////        return 2
////    }
////    else {
////        return 3
////    }
////
//    print(sentComment)
//    print(sentIndex)
//    
//    print(collectionView.tag)
//    
//    
//    if sentComment.count > 0 {
//        if collectionView.tag == sentIndex {
//            return sentComment[0].commentReplies.count
//        }
//        else {
//            return 0
//        }
//
//    }
//    else {
//        return 0
//    }
////    print(sharedCommentReplies)
////    return sharedCommentReplies.count
//    }
////    print(specificReplies)
////    print(collectionView.tag)
////    print(specificReplies[collectionView.tag].commentReplies.count)
////    return specificReplies[collectionView.tag].commentReplies.count
//
//    
//
//
//
//func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "responseCommentsCollectionCell", for: indexPath) as? ResponseCommentsCollectionViewCell
//    cell!.layer.cornerRadius = 10
//    //cell?.responseReplyLabel.text = specificReplies[collectionView.tag].commentReplies.map({$0.discussionCommentReplyTitle})[indexPath.row]
////    cell?.responseReplyLabel.text = discussionCommentRepliesSortedList.map({$0.discussionCommentReplyTitle})[indexPath.row]
//    
//    return cell!
//}
//}
//
//
