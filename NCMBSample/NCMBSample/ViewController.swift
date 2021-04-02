//
//  ViewController.swift
//  NCMBSample
//
//  Created by 樋口裕貴 on 2020/04/16.
//  Copyright © 2020 Yuki Higuchi. All rights reserved.
//

import UIKit
import NCMB


class ViewController: UIViewController {
    
    @IBOutlet var sampleTextField : UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func save () {
        let object = NCMBObject(className: "Message")
        object?.setObject(sampleTextField.text, forKey: "text")
        object?.saveInBackground({ (error) in
            if error != nil{
                //もしエラーが発生したら
             print("error")
            }else{
                //保存に成功した場合
                print("success")
            }
        })
        
        
        
    }
    
    @IBAction func loaddata () {
        let query = NCMBQuery(className: "Message")
        query?.findObjectsInBackground({ (result, error) in
            if error != nil{
                print(error)
            }else{
                let message = result as! [NCMBObject]
                let text = message.last?.object(forKey: "text") as! String
                
                self.sampleTextField.text = text
            }
        })
    }
    @IBAction func update () {
        let query = NCMBQuery(className: "Message")
        query?.whereKey("text", equalTo: "akasatana")
        query?.findObjectsInBackground({ (result, error) in
            if error != nil{
                print(error)
            }else{
                let message = result as! [NCMBObject]
                let textobject = message.first
                textobject?.setObject("ikikiki", forKey: "text")
                
                textobject?.saveInBackground({ (error) in
                    if error != nil{
                        print("error")
                    }else{
                        print("Update")
                    }
                })
                
                
                
        
        
    }
    

})
}
    @IBAction func delete(){
        let query = NCMBQuery(className: "Message")
        query?.whereKey("text", equalTo: "Tesoro")
        query?.findObjectsInBackground({ (result, error) in
            if error != nil{
                print(error)
                
            }else{
                let message = result as! [NCMBObject]
                let textobject = message.first
                textobject?.deleteInBackground({ (error) in
                    if error != nil{
                    print(error)
                    }else{
                    print("delete")
                    }
                })
                
                
            }
        })
        
    }
    
}
