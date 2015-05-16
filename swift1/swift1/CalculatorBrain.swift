//
//  CalculatorBrain.swift
//  swift1
//
//  Created by Ghadge, Vishal Gulab (external - Project) on 2/12/15.
//  Copyright (c) 2015 SAP. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private enum Op{
        case Operand(Double)
        case UnaryOperation(String, Double->Double)
        case BinaryOperation(String, (Double,Double )->Double)
    }
    
    
    private var opStack = [Op]()
    private var knowOps =[String:Op]()
    
    init(){
        knowOps["×"] = Op.BinaryOperation("×", {$0*$1})
        knowOps["÷"] = Op.BinaryOperation("÷", {$1/$0})
        knowOps["+"] = Op.BinaryOperation("+", {$1+$0})
        knowOps["−"] = Op.BinaryOperation("−") {$1-$0}
        knowOps["√"] = Op.UnaryOperation("√",sqrt)
    }
    
    func pushOparand(operand:Double){
        opStack.append(Op.Operand(operand))
    }
    
    func performOperation(symbol: String){
        let operation = knowOps[symbol]{
            opStack.append(operation)
        }
    }
    
    private func evaluate(ops:[Op])->(result:Double?, remainingOps:[Op]){
        if !ops.isEmpty{
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op{
            case .Operand(let operand):
                return(operand, remainingOps)
            case .UnaryOperation(_, let operation):
                
                    let operationevaluation = evaluate(remainingOps)
                    if let operand = operationevaluation.result{
                        return (operation(operand),remainingOps)
                    }
                
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result{
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result{
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }else{
            return (nil, ops)
        }
    }
}