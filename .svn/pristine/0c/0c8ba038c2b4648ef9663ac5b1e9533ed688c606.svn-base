//
//  DatePickViewController.swift
//  renchuanliandong
//
//  Created by 裘鸿 on 12/21/15.
//  Copyright © 2015 qiuhhong. All rights reserved.
//

import UIKit

protocol DatePickViewControllerDelegate: class{
    func datePickDidFinished(controller: DatePickViewController, didFinishedPickDate date:String)
}

class DatePickViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    
    var date:String!
    
    weak var delegate: DatePickViewControllerDelegate?
    
    @IBAction func ok() {
        delegate?.datePickDidFinished(self, didFinishedPickDate: date)
    }
    
    @IBAction func cancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func dateValueChanged(sender: AnyObject) {
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "YYYY-MM-dd HH:mm"
        date = timeFormatter.stringFromDate(datePicker.date)
        dateLabel.text = date
        okButton.enabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .Custom
        transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        okButton.enabled = false
        datePickerView.layer.cornerRadius = 13.0
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DatePickViewController.cancel))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        datePickerView.center.y += 250
        UIView.animateWithDuration(0.25, delay: 0.0, options: .CurveEaseOut, animations: {
            self.datePickerView.frame.origin.y -= 250
        }, completion: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animateWithDuration(0.25, delay: 0.0, options: .CurveEaseOut, animations: {
            self.datePickerView.frame.origin.y += 250
        }, completion: nil)
    }
}

extension DatePickViewController: UIViewControllerTransitioningDelegate{
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return AlphaPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
}

extension DatePickViewController: UIGestureRecognizerDelegate{
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return (touch.view === self.view)
    }
}
