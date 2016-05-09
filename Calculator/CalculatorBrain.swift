//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Tatiana Kornilova on 5/9/16.
//  Copyright © 2016 Tatiana Kornilova. All rights reserved.
//

import Foundation

class CalculatorBrain{

    private var accumulator = 0.0

    func setOperand(operand: Double) {
        accumulator = operand
    }

    private var operations : [String: Operation] = [
        "rand": Operation.NullaryOperation(drand48),
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "±": Operation.UnaryOperation({ -$0 }),
        "√": Operation.UnaryOperation(sqrt),
        "cos": Operation.UnaryOperation(cos),
        "sin": Operation.UnaryOperation(sin),
        "tan" : Operation.UnaryOperation(tan),
        "sin⁻¹" : Operation.UnaryOperation(asin),
        "cos⁻¹" : Operation.UnaryOperation(acos),
        "tan⁻¹" : Operation.UnaryOperation(atan),
        "ln" : Operation.UnaryOperation(log),
        "x⁻¹" : Operation.UnaryOperation({1.0/$0}),
        "х²" : Operation.UnaryOperation({$0 * $0}),
        "×": Operation.BinaryOperation({$0 * $1}),
        "÷": Operation.BinaryOperation({$0 / $1}),
        "+": Operation.BinaryOperation({$0 + $1}),
        "−": Operation.BinaryOperation({$0 - $1}),
        "xʸ" : Operation.BinaryOperation({pow($0, $1)}),
        "=": Operation.Equals,
        "C" : Operation.C
    ]

    private enum Operation{
        case NullaryOperation(() -> Double)
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
        case C
    }

    func performOperation(symbol: String){
        if let operation = operations[symbol]{
            switch operation {
            case .NullaryOperation(let function):
                accumulator = function()
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executeBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryOperation: function, firstOperand: accumulator)
            case .Equals:
                executeBinaryOperation()
            case .C:
                clear()
            }
        }
    }

    private func executeBinaryOperation(){
        if pending != nil{
            accumulator = pending!.binaryOperation(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private func clear() {
        accumulator = 0.0
        pending = nil
    }
    

    private var pending: PendingBinaryOperationInfo?

    private struct PendingBinaryOperationInfo {
        var binaryOperation: (Double, Double) ->Double
        var firstOperand: Double
    }

    var result: Double{
        get{
            return accumulator
        }
    }
}