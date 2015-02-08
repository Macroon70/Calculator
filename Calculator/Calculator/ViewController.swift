//
//  ViewController.swift
//  Calculator
//
//  Created by Gabor L Lizik on 01/02/15.
//  Copyright (c) 2015 Gabor L Lizik. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var operationsList: UILabel!

    var userIsInTheMiddleOfTypingANumber: Bool = false
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
        display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func addDecimal() {
        let decimalPosition = display.text!.rangeOfString(".")
        if decimalPosition == nil {
            userIsInTheMiddleOfTypingANumber = true
            display.text! += "."
        }
    }
    
    @IBAction func addPi() {
        display.text = "\(M_PI)"
        enter()
    }
    
    @IBAction func clearAll() {
        display.text = "0"
        operationsList.text = ""
        userIsInTheMiddleOfTypingANumber = false
        operandStack.removeAll(keepCapacity: false)
    }
    
    @IBAction func clear() {
        display.text = "0"
        userIsInTheMiddleOfTypingANumber = false
    }
    
    @IBAction func backSpace() {
        display.text = dropLast(display.text!)
        if countElements(display.text!) == 0 {
            display.text = "0"
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        switch operation {
        case "×": performOperation({ $0 * $1 }, _operator: operation)
        case "÷": performOperation({ $1 / $0 }, _operator: operation)
        case "+": performOperation({ $0 + $1 }, _operator: operation)
        case "−": performOperation({ $1 - $0 }, _operator: operation)
        case "√": performOperation({ sqrt($0) }, _operator: operation)
        case "sin": performOperation({ sin($0) }, _operator: operation)
        case "cos": performOperation({ cos($0) }, _operator: operation)
        default: break
        }
    }
    
    func performOperation(operation: (Double, Double) -> Double, _operator: String) {
        if operandStack.count >= 2 {
            let secondValue = operandStack.removeLast()
            let firstValue = operandStack.removeLast()
            displayValue = operation(secondValue, firstValue)
            operationsList.text! = "( \(firstValue) \(_operator) \(secondValue)) ="
            enter()
        }
    }
    
    func performOperation(operation: Double -> Double, _operator: String) {
        if operandStack.count >= 1 {
            let lastValue = operandStack.removeLast()
            displayValue = operation(lastValue)
            operationsList.text! = "( \(_operator)(\(lastValue))) ="
            enter()
        }
    }
    
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        operationsList.text! += " \(display.text!) ↵ "
        operationsList.sizeToFit()
        println("operandStack = \(operandStack)")
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}

