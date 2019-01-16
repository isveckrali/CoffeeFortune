//
//  OrderModel.swift
//  CoffeeFortune
//
//  Created by Flyco Developer on 15.01.2019.
//  Copyright © 2019 Flyco Global. All rights reserved.
//

import Foundation
import Parse

struct OrderModel {
    
    var userId: String!
    var subject : Int!
    var status: Int!
    var text: String!
    var image1: String?
    var image2: String?
    var name:String!
    var createdAt:Date?
    
}
