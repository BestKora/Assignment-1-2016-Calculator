//
//  ViewController.swift
//  Calculator
//
//  Created by Tatiana Kornilova on 5/9/16.
//  Copyright © 2016 Tatiana Kornilova. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var history: UILabel!
    @IBOutlet private weak var display: UILabel!
    @IBOutlet weak var tochka: UIButton!{
        didSet {
            tochka.setTitle(decimalSeparator, forState: UIControlState.Normal)
        }
    }
    
    private var userIsInTheMiddleOfTyping = false
    let decimalSeparator = formatter.decimalSeparator ?? "."
    
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            //----- Уничтожаем лидирующие нули -----------------
            if (digit == "0") && ((display.text == "0") || (display.text == "-0")){ return }
            if (digit !=  decimalSeparator) && ((display.text == "0") || (display.text == "-0"))
            { display.text = digit ; return }
            //--------------------------------------------------

            if (digit != decimalSeparator) || (textCurrentlyInDisplay.rangeOfString(decimalSeparator) == nil) {
                display.text = textCurrentlyInDisplay + digit
            }
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
    private var displayValue: Double? {
        get {
            if let text = display.text,
                value = formatter.numberFromString(text)?.doubleValue {
                return value
            }
            return nil
        }
        set {
            if let value = newValue {
                display.text = formatter.stringFromNumber(value)
                history.text = brain.description + (brain.isPartialResult ? " …" : " =")
            } else {
                display.text = " "
                history.text = " "
                userIsInTheMiddleOfTyping = false
            }
        }
    }

    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            if let value = displayValue{
                brain.setOperand(value)
            }
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle{
            brain.performOperation(mathematicalSymbol)
        }
        displayValue = brain.result
        
    }
    
    @IBAction func backspace(sender: UIButton) {
        if userIsInTheMiddleOfTyping  {
            display.text!.removeAtIndex(display.text!.endIndex.predecessor())
        }
        if display.text!.isEmpty {
            userIsInTheMiddleOfTyping  = false
            displayValue = brain.result
        }
    }
    @IBAction func plusMinus(sender: UIButton) {
        if userIsInTheMiddleOfTyping  {
            if (display.text!.rangeOfString("-") != nil) {
                display.text = String((display.text!).characters.dropFirst())
            } else {
                display.text = "-" + display.text!
            }
        } else {
            performOperation(sender)
        }
    }


}

