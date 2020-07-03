//
//  String.swift
//  Messaging app (WebSocket)
//
//  Created by Олег Еременко on 03.07.2020.
//  Copyright © 2020 Oleg Eremenko. All rights reserved.
//

import Foundation

extension String {
    var isCyrillic: Bool {
        let upper = "АБВГДЕËЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ"
        let lower = "абвгдеёжзийклмнопрстуфхцчшщъыьэюя"

        for c in self.map({ String($0) }) {
            if !upper.contains(c) && !lower.contains(c) { return false }
        }
        return true
    }
}

