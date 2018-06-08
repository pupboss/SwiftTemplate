//
//  SendCodeButton.swift
//  SwiftTemplate
//
//  Created by Jet Lee on 3/6/18.
//  Copyright © 2018 PUPBOSS. All rights reserved.
//

import UIKit

class SendCodeButton: UIButton {

    private(set) var isWaiting: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitle("Send", for: .normal)
        setTitleColor(UIColor.tc.background, for: .normal)
        setTitleColor(UIColor.tc.disableText, for: .disabled)
        
        setBackgroundImage(UIImage.fromColor(.clear), for: .disabled)
        layer.borderWidth = 1
        layer.borderColor = UIColor.tc.tint.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func enterDisableMode() {
        isEnabled = false
        isWaiting = true
        
        var seconds = 59
        
        let timer =  DispatchSource.makeTimerSource(flags: [], queue:DispatchQueue.main)
        timer.schedule(deadline: .now(), repeating: .seconds(1) ,leeway:.seconds(seconds))
        timer.setEventHandler {
            if seconds <= 0 {
                timer.cancel()
                DispatchQueue.main.sync {
                    self.setTitle("Resend", for: .normal)
                    self.isEnabled = true
                    self.isWaiting = false
                }
            } else {
                DispatchQueue.main.sync {
                    self.setTitle(String(format: "%.2ds", seconds), for: .normal)
                    self.isEnabled = false
                    self.isWaiting = true
                }
                seconds -= 1
            }
        }
        timer.resume()
    }
}
