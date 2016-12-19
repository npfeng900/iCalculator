//
//  CalculatorBrain.swift
//  iCalculator
//
//  Created by Niu Panfeng on 19/12/2016.
//  Copyright © 2016 NaPaFeng. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    enum Op: CustomStringConvertible
    {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        //print()函数用
        var description: String {
            get {
                switch self
                {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    /** 操作元素栈 */
    var opStack = [Op]()
    /** 已登记的操作符号 */
    var kownOps = Dictionary<String, Op>()
    
    init() {
        /** 初始化kownOps */
        func learnOp(op: Op) {
            kownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("+", {$0 + $1}))
        
        kownOps["−"] = Op.BinaryOperation("−", {$1 - $0})
        kownOps["×"] = Op.BinaryOperation("×", *)
        kownOps["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
        kownOps["√"] = Op.UnaryOperation("√", sqrt)
    }
    /** 递归运算 */
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]){
        if ops.isEmpty == false
        {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op
            {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let evaluateResult = evaluate(remainingOps)
                if let operand = evaluateResult.result
                {
                    return ( operation(operand), evaluateResult.remainingOps )
                }
            case .BinaryOperation(_, let operation):
                let evaluateResult1 = evaluate(remainingOps)
                if let operand1 = evaluateResult1.result
                {
                    let evaluateResult2 = evaluate(evaluateResult1.remainingOps)
                    if let operand2 = evaluateResult2.result
                    {
                        return ( operation(operand1, operand2), evaluateResult2.remainingOps )
                    }
                }
            }
        }
        
        return (nil, ops)
    }
    /** 运算opStack的结果 */
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left")
        return result
    }
    
    /** 添加operand，返回运算结果 */
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    /** 添加Operation，返回运算结果 */
    func performOperation(symbol: String) -> Double? {
        if let operation = kownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
}