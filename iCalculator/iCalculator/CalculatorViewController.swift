//
//  ViewController.swift
//  iCalculator
//
//  Created by Niu Panfeng on 19/12/2016.
//  Copyright © 2016 NaPaFeng. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var displayValue: Double {
        get {
            return  NSString(string: display.text!).doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    var userIsInTheMiddleOfTypingANumber: Bool = false
    
    var brain = CalculatorBrain()
    
    /** 构造Digit */
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber
        {
            display.text = display.text! + digit
        }
        else
        {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
        
    }
    /** 添加operand，并计算结果 */
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        brain.pushOperand(displayValue)
    }
    /** 添加Operation，并计算结果 */
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle
        {
            if let result = brain.performOperation(operation)
            {
                displayValue = result
            }
            else
            {
                displayValue = 0
            }
        }
    }
 

}

