//
//  ViewController.swift
//  calculator-exercise
//
//  Created by dimarchi on 23/09/2017.
//  Copyright © 2017 dimarchi. All rights reserved.
//
//  Simple home exercise given at the iOS course I'm
//  participating in. Does not function corrently
//  (try 9/2, the result is 4.0), therefore needs
//  refactoring and error checking, which is also
//  missing.
//  Inspired by https://github.com/fnk0/iOS-Calculator-Tutorial
//
// Updated with division bug fix 2018-02-03

import UIKit
import Foundation

extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}

class ViewController: UIViewController {
    
    var calcString : String = ""
    var newString : String = ""
    var resultString : String = ""
    var digitCheck : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // label where input appears
    @IBOutlet weak var resultLabel: UILabel!
    
    // button action
    @IBAction func handleButtonPress(_ sender: UIButton)
    {
        let buttonText = sender.titleLabel?.text
        
        if let text = buttonText
        {
            switch text
            {
                case "=":
                    let numbers = newString.components(separatedBy: ["+", "-", "*", "/"])
                    let operators = newString.components(separatedBy: CharacterSet.decimalDigits)
                    parseStrings(numbers, operators)
                    newString = ""
                    calcString = ""
                    break
                case "C":
                    resultLabel.text = ""
                    break
                default:
                    newString.append(contentsOf: buttonText!)
                    resultLabel.text = newString
                    break
            }
        }
    }
    
    func parseStrings(_ numbers: [String], _ operators: [String])
    {
        let opA = operators
        let opB = ["", "."]
        // operator array filtered from empty and dot strings
        let op = opA.filter({item in !opB.contains(item)})
        let nrLength = numbers.count
        var i = 0
        var mathString : String = ""
        
        for number in numbers
        {
            if number.isInt
            {
                let nr = (number as! NSString).doubleValue
                mathString.append(contentsOf: nr.description)
            }
            else
            {
                mathString.append(contentsOf: number.description)
            }
            if (i + 1) < nrLength
            {
                mathString.append(contentsOf: op[i])
                i = i + 1
            }
        }
        
        calculate2(mathString)
    }
    
    // calculate string
    func calculate2(_ mathExpression : String)
    {
        let mathString = NSExpression(format: mathExpression)
        
        guard let result = mathString.expressionValue(with: nil, context: nil) as? Double else
        {
            //resultLabel.text = "ERROR"
            return
        }
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        guard let value = formatter.string(from: NSNumber(value: result)) else
        {
            //resultLabel.text = "ERROR"
            return
        }
        resultLabel.text = "\(value)"
    }
}
