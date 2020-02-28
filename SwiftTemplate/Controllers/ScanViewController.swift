//
//  ScanViewController.swift
//  SwiftTemplate
//
//  Created by Jet Lee on 5/6/18.
//  Copyright © 2018 PUPBOSS. All rights reserved.
//

import UIKit
import SnapKit

class ScanViewController: UIViewController {
    
    lazy var sessionManager: AVCaptureSessionManager? = {
        var sManager: AVCaptureSessionManager? = nil
        AVCaptureSessionManager.checkAuthorizationStatusForCamera(grant: {
            sManager = AVCaptureSessionManager(captureType: .both, scanRect: .null, success: { (result) in
                if let r = result {
                    self.scanFinishedWithResult(result: r)
                }
            })
            sManager!.showPreViewLayerIn(view: self.view)
            sManager!.isPlaySound = true
        }, denied: {
            let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                let url = URL(string: UIApplication.openSettingsURLString)
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            })
            let alert = UIAlertController(title: "Permission denied", message: "Please allow camera permission to make barcode detection", preferredStyle: .alert)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        })
        return sManager
    }()
    
    lazy var borderImageView: UIImageView = {
        let borderImageView = UIImageView(image: UIImage(named: "img_qrcode_border"))
        borderImageView.contentMode = .scaleToFill
        return borderImageView
    }()
    
    var onScreen = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.tc.background

        view.addSubview(borderImageView)
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let sessionManager = sessionManager {
            sessionManager.start()
        }
        UIApplication.shared.isIdleTimerDisabled = true
        navigationController?.isNavigationBarHidden = true
        onScreen = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.isIdleTimerDisabled = false
        navigationController?.isNavigationBarHidden = false
        onScreen = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let sessionManager = sessionManager {
            sessionManager.stop()
        }
    }
    
    func scanFinishedWithResult(result: String) {
        if !onScreen {
            return
        }
        
        let action = UIAlertAction(title: "OK", style: .default) { (_) in
            
            if let sessionManager = self.sessionManager {
                sessionManager.start()
            }
        }
        let alert = UIAlertController(title: "Content", message: result, preferredStyle: .alert)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func setupConstraints() {
        borderImageView.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.width.equalTo(250)
            make.height.equalTo(155)
        }
    }
}
