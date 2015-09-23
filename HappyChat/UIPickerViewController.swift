//
//  UIPickerViewController.swift
//  HappyChat
//
//  Created by Dorothy Thurston on 9/18/15.
//  Copyright © 2015 Dorothy Thurston. All rights reserved.
//

import UIKit

protocol UIPickerViewControllerDelegate {
    func newMessageChoiceMade(choice: String)
}

class UIPickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var myPicker: UIPickerView!
    
    var delegate: UIPickerViewControllerDelegate?
    var pickerData = [" wonderful!"," fabulous"," awesome"," amazing"," 😄"," 🌟"," ☺️"]
    var messageChoice = " wonderful!"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myPicker.dataSource = self
        myPicker.delegate = self
    }
    
    @IBAction func didPressCancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didPressSelect(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.delegate?.newMessageChoiceMade(self.messageChoice)
    }
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        messageChoice = pickerData[row]
    }
}
