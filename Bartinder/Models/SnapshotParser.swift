//
//  SnapshotParser.swift
//  Bartinder
//
//  Created by Andreas Lengkeek on 19/5/18.
//  Copyright © 2018 Bartinder. All rights reserved.
//

import Foundation
import Firebase

protocol SnapshotParser {
    init(with snapshot: DataSnapshot)
}
