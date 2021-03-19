//
//  Message.swift
//  BreakPoint
//
//  Created by Mohamed on 2/5/21.
//  Copyright © 2021 Refa3y. All rights reserved.
//

import Foundation
class Message {
    private var _content: String
    private var _senderID: String
    
    var content: String {
        return _content
    }
    
    var senderID: String {
        return _senderID
    }
    
    init(content: String, senderID: String) {
        _content = content
        _senderID = senderID
    }
    
}

