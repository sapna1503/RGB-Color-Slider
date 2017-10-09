//
//  ViewController.swift
//  RGB Color Slider
//
//  Created by Sapna Chandiramani on 10/4/17.
//  Copyright © 2017 Sapna Chandiramani. All rights reserved.
//  RED ID -: 822131577

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtRed: UICustomTextField!
    @IBOutlet weak var txtGreen: UICustomTextField!
    @IBOutlet weak var txtBlue: UICustomTextField!
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var viewColor: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        InitialiseValues()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(_ animated: Bool) {
        let redText: String? = UserDefaults.standard.object(forKey: "RedTextValue") as! String?
        if let redTextValue = redText {
            txtRed.text = redTextValue
            changeSliderValueOnTextChange(txtRed)
        }
        let greenText: String? = UserDefaults.standard.object(forKey: "GreenTextValue") as! String?
        if let greenTextValue = greenText {
            txtGreen.text = greenTextValue
            changeSliderValueOnTextChange(txtGreen)
        }
        let blueText: String? = UserDefaults.standard.object(forKey: "BlueTextValue") as! String?
        if let blueTextValue = blueText {
            txtBlue.text = blueTextValue
            changeSliderValueOnTextChange(txtBlue)
        }

        let backColor: UIColor? = UserDefaults.standard.colorForKey(key: "ViewColor")
        if let backgroundColor = backColor {
            viewColor.backgroundColor = backgroundColor
        }
    }

    @IBAction func changeSliderValueOnTextChange(_ sender: UITextField) {
        if let stringValue = sender.text {
            if let floatValue = Float(stringValue) {
                let tag: Double = Double(sender.tag)
                switch tag {
                case 1:
                    redSlider.setValue(floatValue, animated: true)
                case 2:
                    greenSlider.setValue(floatValue, animated: true)
                case 3:
                    blueSlider.setValue(floatValue, animated: true)
                default:
                    break
                }
            }
        }
    }

    // On slider value change changes textbox value and color in view
    @IBAction func changeTextAndColorOnSliderValueChange(_ sender: Any) {
        txtRed.text = String(redSlider.value)
        txtGreen.text = String(greenSlider.value)
        txtBlue.text = String(blueSlider.value)
        changeViewColor()
        setUserDefaults()
        setViewColorToUserDefault()
    }

    @IBAction func textEditingEnd(_ sender: UITextField) {
        if(sender.text! == "") {
            sender.text = "0.0"
            changeSliderValueOnTextChange(sender)
        }

        let decimalTuples = sender.text!.components(separatedBy: ".")
        if (decimalTuples.count > 2) {
            createAlert(title: "Invalid Input", message: "Please enter number in range of 0 to 100")
            sender.text = "0.0"
        }

        let roundedString = String(round(10000 * Double(sender.text!)!) / 10000)
        if ((roundedString != "0.0") && ((sender.text)?.contains("."))!) {
            sender.text = roundedString
        }
        setUserDefaults()
    }

    @IBAction func textEditingChanged(_ sender: UITextField) {
        setUserDefaults()
        guard sender.text!.count < 3 else {
            if let doubleValue = Double(sender.text!) {
                guard doubleValue <= 100 else {
                    createAlert(title: "Input is out of range", message: "Please enter number in range of 0 to 100")
                    sender.text = "100.0"
                    return
                }
            }
            setUserDefaults()
            return
        }
    }

    @IBAction func btnColor(_ sender: UIButton) {
        txtRed.resignFirstResponder()
        txtGreen.resignFirstResponder()
        txtBlue.resignFirstResponder()
        changeViewColor()
        setUserDefaults()
        setViewColorToUserDefault()
    }

    // To validate only numbers in text fields and text length upto 3 digits
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let countdots = textField.text!.components(separatedBy: ".").count - 1
        if countdots > 0 && string == "." {
            return false
        }
        let aSet = NSCharacterSet(charactersIn: "0123456789.").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }

    private func InitialiseValues() {
        redSlider.value = 0
        greenSlider.value = 0
        blueSlider.value = 0

        txtRed.keyboardType = UIKeyboardType.decimalPad
        txtGreen.keyboardType = UIKeyboardType.decimalPad
        txtBlue.keyboardType = UIKeyboardType.decimalPad

        changeViewColor()

        // For text delegateTo validate only numbers
        self.txtRed.delegate = self
        self.txtGreen.delegate = self
        self.txtBlue.delegate = self

        //To change slider value on textbox change
        txtRed.addTarget(self, action: #selector(changeSliderValueOnTextChange(_:)), for: .editingChanged)
        txtGreen.addTarget(self, action: #selector(changeSliderValueOnTextChange(_:)), for: .editingChanged)
        txtBlue.addTarget(self, action: #selector(changeSliderValueOnTextChange(_:)), for: .editingChanged)
    }

    private func setUserDefaults() {
        //To store textbox values after app killed
        UserDefaults.standard.set(txtRed.text, forKey: "RedTextValue")
        UserDefaults.standard.set(txtGreen.text, forKey: "GreenTextValue")
        UserDefaults.standard.set(txtBlue.text, forKey: "BlueTextValue")

        //To store textbox values after app killed
        UserDefaults.standard.set(redSlider.value, forKey: "RedSliderValue")
        UserDefaults.standard.set(greenSlider.value, forKey: "GreenSliderValue")
        UserDefaults.standard.set(blueSlider.value, forKey: "BlueSliderValue")
    }

    private func setViewColorToUserDefault() {
        UserDefaults.standard.setColor(color: viewColor.backgroundColor, forKey: "ViewColor")
    }

    //Function to give alert
    private func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in alert.dismiss(animated: true, completion: nil) }))
        self.present(alert, animated: true, completion: nil)
    }

    private func changeViewColor() {
        viewColor.backgroundColor = UIColor(red: CGFloat((redSlider.value) / 100), green: CGFloat((greenSlider.value) / 100), blue: CGFloat((blueSlider.value) / 100), alpha: 1)
    }
}

//Custom Text Field to disable Paste action while copied string contains characters other than 0123456789.
class UICustomTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            let pasteboardString: String? = UIPasteboard.general.string
            if let string = pasteboardString {
                let aSet = NSCharacterSet(charactersIn: "0123456789.").inverted
                let compSepByCharInSet = string.components(separatedBy: aSet)
                let numberFiltered = compSepByCharInSet.joined(separator: "")
                return string == numberFiltered
            }
        }
        return super.canPerformAction(action, withSender: sender)
    }
}


extension UserDefaults {
    func colorForKey(key: String) -> UIColor? {
        var color: UIColor?
        if let colorData = data(forKey: key) {
            color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
        }
        return color
    }
    func setColor(color: UIColor?, forKey key: String) {
        var colorData: NSData?
        if let color = color {
            colorData = NSKeyedArchiver.archivedData(withRootObject: color) as NSData?
        }
        set(colorData, forKey: key)
    }
}

