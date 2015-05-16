//
//  data.swift
//  SwiftPractice
//
//  Created by Ghadge, Vishal Gulab (external - Project) on 4/22/15.
//  Copyright (c) 2015 SAP. All rights reserved.
//

import Foundation

class Box<T>{
    let unbox: T
    init(_ value:T){
        self.unbox = value
    }
}

enum Result<T>{
    case Value(Box<T>)
    case Error(NSError)
    
    func map<U>(f: T -> U ) ->Result<U>{
        switch self {
        case let .Value(value):
            return Result<U>.Value(Box(f(value.unbox)))
        case let .Error(error):
            return Result<U>.Error(error)
        }

    }

//extension Result{
//        }
    
    func flatten<U>(result: Result<Result<T>>) -> Result<T>{
        switch result{
        case let .Value(innerValue):
            return innerValue.unbox
        case let .Error(error):
            return Result<T>.Error(error)
        }
    }
}

func dataWithContentsOfFile(file: String, encoding: NSStringEncoding ) -> Result<NSData>{
    var error: NSError?
    if let data = NSData(contentsOfFile: file, options: .allZeros, error: &error ){
        return .Value(Box(data))
    }else{
        println(error)
        return .Error(error!)
    }
}

func test(){
    let data = dataWithContentsOfFile("/Users/c5194438/code/ios/1.txt", NSUTF8StringEncoding)
    let uppercaseString = data.map{ NSString(data: $0 ,encoding: NSUTF8StringEncoding)! }.map{ $0.uppercaseString }
    println(uppercaseString)
}
