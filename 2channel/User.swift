//
//  User.swift
//  2channel
//
//  Created by 樋口裕貴 on 2020/08/27.
//  Copyright © 2020 Yuki Higuchi. All rights reserved.
//

import UIKit

class User {
    var objectId: String
    var userName: String
    var displayName: String?
    var introduction: String?

    init(objectId: String, userName: String) {
        self.objectId = objectId
        self.userName = userName
    }
}
