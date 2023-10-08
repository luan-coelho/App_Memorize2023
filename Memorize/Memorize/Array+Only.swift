//
//  Array+Only.swift
//  Memorize
//
//  Created by Sósthenes Oliveira Lima on 08/10/23.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
