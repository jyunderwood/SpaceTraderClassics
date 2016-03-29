//
//  SellPickerVC.swift
//  SpaceTrader
//
//  Created by Marc Auger on 3/19/16.
//  Copyright © 2016 Marc Auger. All rights reserved.
//

import UIKit

class SellPickerVC: UIViewController {
    
    
    @IBOutlet weak var firstLabel: StandardLabel!
    @IBOutlet weak var secondLabel: StandardLabel!
    @IBOutlet weak var quantityLabel: PurpleHeader!
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sellButton: PurpleButtonTurnsGray!
    
    let commodity = buySellCommodity!                        // this is stored as a global
    let max = player.commanderShip.getQuantity(buySellCommodity!)
    var sellAsOpposedToDump = true                      // placeholder; set in viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set color of slider
        slider.tintColor = mainPurple
        
        // see whether sell or dump
        let localPrice = galaxy.currentSystem!.getSellPrice(commodity)
        if localPrice > 0 {
            sellAsOpposedToDump = true
        } else {
            sellAsOpposedToDump = false
        }
        
        // set page title & button name
        let controlState = UIControlState()
        if sellAsOpposedToDump {
            self.title = "Sell \(commodity.rawValue)"
            sellButton.setTitle("Sell", forState: controlState)
        } else {
            self.title = "Dump \(commodity.rawValue)"
            sellButton.setTitle("Dump", forState: controlState)
        }
        
        
        // set slider max and min
        slider.minimumValue = 0
        slider.maximumValue = Float(max)
        slider.value = 0
        
        updateUI()
    }
    
    func updateUI() {
        // set labels
        if sellAsOpposedToDump {
            firstLabel.text = "You can sell up to \(max) bays of \(commodity.rawValue)."
            secondLabel.text = "How many would you like to sell?"
            quantityLabel.text = "\(Int(slider.value)) bays"
        } else {
            firstLabel.text = "You can dump up to \(max) bays of \(commodity.rawValue)."
            secondLabel.text = "How many would you like to dump?"
            quantityLabel.text = "\(Int(slider.value)) bays"
        }
        
        
        // disable sell if quantity is zero
        if slider.value == 0 {
            sellButton.enabled = false
        } else {
            sellButton.enabled = true
        }
    }
    
    @IBAction func sliderMoved(sender: AnyObject) {
        updateUI()
    }
    
    @IBAction func sellPressed(sender: AnyObject) {
        
        
        if sellAsOpposedToDump {
            // sell and close
            player.sell(commodity, quantity: Int(slider.value))
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            // dump--confirm
            let title = "Dump \(commodity.rawValue)?"
            let message = "Are you sure you want to dump \(Int(slider.value)) bays of \(commodity.rawValue)?"
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dump", style: UIAlertActionStyle.Destructive ,handler: {
                (alert: UIAlertAction!) -> Void in
                // dump and close
                player.commanderShip.removeCargo(self.commodity, quantity: Int(self.slider.value))
                //self.navigationController?.popToRootViewControllerAnimated(true)
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
            alertController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default ,handler: {
                (alert: UIAlertAction!) -> Void in
                // do nothing
            }))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func cancelPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
