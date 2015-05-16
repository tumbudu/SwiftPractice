//: Playground - noun: a place where people can play

import UIKit

class Box<T>{
    let value: T
    init(_ value:T){
        self.value = value
    }
    
    func map<U>( f: T -> U)->Box<U>{
        return Box<U>(f(self.value))
    }
    
    func flatten<T>(box: Box<Box<T>>) ->Box<T>{
        return box.value
    }
    
    func flatMap<U>(f: T->Box<U>)  -> Box<U>{
        return flatten(map(f))
    }
}

// The bind operator is for transferring one monadic value to another monadic value via a function that takes the non-monadic value as a parameter.
infix operator  >>=  {associativity left}
func >>= <T,U>(box : Box<T>, f : T -> Box<U>) -> Box<U> {
    return box.flatten(box.map(f))
}

let box = Box(4)
let sum3 = { Box($0 + 3 ) }
let toString = { Box(String ($0+0))}
let iReallyLike = {Box("I really like the number " + $0 ) }

let lucky1 = (((box.flatMap(sum3)).flatMap(toString)).flatMap(iReallyLike))
let lucky2 = iReallyLike(toString(sum3(box.value).value).value)
let lucky3 = box >>= sum3 >>= toString >>= iReallyLike

println(lucky1.value)


//Monad laws:
//1. Left Identify
let f = { Box($0 + 1) }
let a = 1

let x = Box(a) >>= f //Box(a).flatMap(f)
let y = f(a)
x.value == y.value

//2. Right Identity


//3. Associativity
//monadic composition is associative
