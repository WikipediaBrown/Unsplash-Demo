//
//  Queue.swift
//  Unsplash-Demo
//
//  Created by Wikipedia Brown on 11/4/19.
//  Copyright © 2019 IamGoodBad. All rights reserved.
//

import Foundation

struct Queue<T> {

    var allElements: [T?] {Array(array[head...array.index(before: array.endIndex)])}
    var back: T? { return isEmpty ? nil : array[array.index(before: array.endIndex)]}
    var count: Int { return array.count - head}
    var front: T? { return isEmpty ? nil : array[head] }
    var isEmpty: Bool { return count == 0 }
    
    private var array = [T?]()
    private var head = 0
        
    mutating func dequeue() -> T? {
        guard head < array.count, let element = array[head] else { return nil }
        array[head] = nil
        head += 1
        
        let percentage = Double(head)/Double(array.count)
        if array.count > 100 && percentage > 0.5 {
          array.removeFirst(head)
          head = 0
        }
        
        return element
    }
    
    
    func element(at index: Int) -> T? {
        guard index < count else { return nil }
        return array[head + index]
    }
    
    mutating func enqueue(_ element: T) {
        array.append(element)
    }
    
    mutating func removeAll() {
        array = [T?]()
        head = 0
    }
}
