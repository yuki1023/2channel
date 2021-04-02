//
//  TimelineViewController.swift
//  2channel
//
//  Created by 樋口裕貴 on 2020/08/27.
//  Copyright © 2020 Yuki Higuchi. All rights reserved.
//
import UIKit
import NCMB
import SVProgressHUD

class TimelineViewController: UIViewController , UITableViewDataSource,UITableViewDelegate, TimelineTableViewCellDelegate{
    
    
  
    
    var users = [String]()
    
    var texts = [String]()
    
    var objIds = [String]()
    
    var isLikedArray = [Bool]()
    
    var isLiked = false
    
    
    @IBOutlet var timelineTableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timelineTableView.dataSource = self
        timelineTableView.delegate = self
        
      
        
        setRefreshControl()
        
        //        カスタムビューの取得
        let nib = UINib(nibName: "TimelineTableViewCell", bundle: Bundle.main)
        timelineTableView.register(nib, forCellReuseIdentifier: "Cell")
        
        timelineTableView.tableFooterView = UIView()
        
        timelineTableView.rowHeight = 360
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
          loadTimeline()
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 152
    }
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return texts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TimelineTableViewCell
        
        cell.delegate = self
        cell.tag = indexPath.row
        
        let user = users[indexPath.row]
        let text = texts[indexPath.row]
        
        cell.userNameLabel.text = user
        cell.tweetTextView.text = text
        
        
        // Likeによってハートの表示を変える
        if isLikedArray[indexPath.row] == true {
            cell.likeButton.setImage(UIImage(named: "heart-fill"), for: .normal)
        } else {
            cell.likeButton.setImage(UIImage(named: "heart-outline"), for: .normal)
        }

       
        
        return cell
    }
    
    func didTapLikeButton(tableViewCell: UITableViewCell, button: UIButton){

        guard let currentUser = NCMBUser.current() else {
            //画面が戻る

            //            ログアウト成功
            let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
            UIApplication.shared.keyWindow?.rootViewController = rootViewController

            //ログイン状態の保持
            let ud = UserDefaults.standard
            ud.set(false, forKey: "isLogin")
            ud.synchronize()
            return
        }

        
        
        
        if isLikedArray[tableViewCell.tag] == false || isLikedArray[tableViewCell.tag] == nil {
            let query = NCMBQuery(className: "Post")
            query?.getObjectInBackground(withId: objIds[tableViewCell.tag], block: { (post, error) in
                post?.addUniqueObject(currentUser.objectId, forKey: "likeUser")
                post?.setObject(true, forKey: "isLiked")
                post?.saveEventually({ (error) in
                    if error != nil {
                        SVProgressHUD.showError(withStatus: error!.localizedDescription)
                    } else {
                        self.loadTimeline()
                    }
                })
            })
        } else {
            let query = NCMBQuery(className: "Post")
            query?.getObjectInBackground(withId: objIds[tableViewCell.tag], block: { (post, error) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
                } else {
                    post?.removeObjects(in: [NCMBUser.current().objectId], forKey: "likeUser")
                    post?.setObject(false, forKey: "isLiked")
                    post?.saveEventually({ (error) in
                        if error != nil {
                            SVProgressHUD.showError(withStatus: error!.localizedDescription)
                        } else {
                            self.loadTimeline()
                        }
                    })
                }
            })
        }


    }
    
    func didTapMenuButton(tableViewCell: UITableViewCell, button: UIButton){
            let query = NCMBQuery(className: "Post")
       query?.getObjectInBackground(withId: objIds[tableViewCell.tag], block: { (post, error) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
                } else {
                        

                        // 取得した投稿オブジェクトを削除
                        post?.deleteInBackground({ (error) in
                            if error != nil {
                                SVProgressHUD.showError(withStatus: error!.localizedDescription)
                            } else {
                                // 再読込
                                self.loadTimeline()
                                SVProgressHUD.dismiss()
                            }
                            
                        })

                    
                
                }
            })
                
        
        
      
    }
    

    
    func loadTimeline (){
        
        let query = NCMBQuery(className: "Post")
        // 降順
        query?.order(byDescending: "createDate")
       
        // オブジェクトの取得
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                // 投稿を格納しておく配列を初期化(これをしないとreload時にappendで二重に追加されてしまう)
                self.users = [String]()
                self.texts = [String]()
                self.objIds = [String]()
                self.isLikedArray = [Bool]()
                
                for postObject in result as! [NCMBObject] {
                    print(result)
                    print(postObject)
                    // ユーザー情報をUserクラスにセット
                    let user = postObject.object(forKey: "user") as! String
                    
                    let text = postObject.object(forKey: "text") as! String
                    
                    let objId = postObject.objectId
                    
                    // likeの状況(自分が過去にLikeしているか？)によってデータを挿入
                    let likeUsers = postObject.object(forKey: "likeUser") as? [String]
                    if likeUsers?.contains(NCMBUser.current().objectId) == true {
                        self.isLiked = true
                    } else {
                        self.isLiked = false
                    }

                    
                   
                    
                    // 配列に加える
                    self.users.append(user)
                    self.texts.append(text)
                    self.objIds.append(objId!)
                    self.isLikedArray.append(self.isLiked)
                    
                    
                                
                            
                        
                        
                  
                        
                        
                        
                        
                    }
                
                // 投稿のデータが揃ったらTableViewをリロード
                    self.timelineTableView.reloadData()
                
                }
                
                
        })
    
        
        
    }
    
    func setRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadTimeline(refreshControl:)), for: .valueChanged)
        timelineTableView.addSubview(refreshControl)
    }
    
    @objc func reloadTimeline(refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        self.loadTimeline()
        // 更新が早すぎるので2秒遅延させる
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            refreshControl.endRefreshing()
        }
    }
    
   
    
    
    
    
}




