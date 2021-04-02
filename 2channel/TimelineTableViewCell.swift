//
//  TimelineTableViewCell.swift
//  2channel
//
//  Created by 樋口裕貴 on 2020/08/27.
//  Copyright © 2020 Yuki Higuchi. All rights reserved.
//

import UIKit


protocol TimelineTableViewCellDelegate {
    func didTapLikeButton(tableViewCell: UITableViewCell, button: UIButton)
    func didTapMenuButton(tableViewCell: UITableViewCell, button: UIButton)
}

class TimelineTableViewCell: UITableViewCell {
    
    var delegate : TimelineTableViewCellDelegate?
    
    
      @IBOutlet var userNameLabel : UILabel!
      
      @IBOutlet var tweetTextView : UITextView!
    
    @IBOutlet var MenuButton : UIButton!
      
    @IBOutlet var likeButton : UIButton!

      

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
 @IBAction func like(button: UIButton) {
     self.delegate?.didTapLikeButton(tableViewCell: self, button: button)
 }

    
 @IBAction func openMenu(button: UIButton) {
     self.delegate?.didTapMenuButton(tableViewCell: self, button: button)
 }

 

}
