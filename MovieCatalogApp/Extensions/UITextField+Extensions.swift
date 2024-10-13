//
//  UITextField+Extensions.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 12.10.2024.
//

import UIKit

extension UITextField {
    
    func configureDatePicker(target: Any, selector: Selector) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.maximumDate = Date()
        
        self.inputView = datePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: target, action: selector)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        
        self.inputAccessoryView = toolbar
    }
    
    func setDate(from datePicker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.text = formatter.string(from: datePicker.date)
    }
}
