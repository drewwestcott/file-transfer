//
//  ViewController.swift
//  file-transfer
//
//  Created by Drew Westcott on 08/05/2017.
//  Copyright © 2017 Drew Westcott. All rights reserved.
//

import UIKit
import WatchConnectivity

class MainVC: UIViewController, WCSessionDelegate {
	/** Called when the session has completed activation. If session state is WCSessionActivationStateNotActivated there will be an error with more details. */
	@available(iOS 9.3, *)
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		print(activationState)
	}

	
	@IBOutlet weak var imageView: UIImageView!
	var backgroundImage: UIImage?
	
	private let session: WCSession? = WCSession.isSupported() ? WCSession.default() : nil
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		var urlPath = Bundle.main.path(forResource: "background", ofType: "jpg")
		print(urlPath!)
		backgroundImage = UIImage(contentsOfFile: urlPath!)
		imageView.image =  backgroundImage
		
		session?.delegate = self
		session?.activate()
		
	}

	@IBAction func sendToWatch() {
		
		var urlPath = Bundle.main.path(forResource: "background", ofType: "jpg")
		let url = URL(fileURLWithPath: urlPath!)
		self.session?.transferFile(url, metadata: nil)
		print("Transfer initiated")
		//self.session?.transfer(urlPath)
		
	}

	func session(session: WCSession, didFinishFileTransfer fileTransfer: WCSessionFileTransfer, error: NSError?) {
		if error == nil {
			print("Transfer Complete")
		} else {
			print(error)
		}
	}
	
	func sessionDidBecomeInactive(_ session: WCSession) {
		print("Session went Inactive")
	}
	
	func sessionDidDeactivate(_ session: WCSession) {
		print("Session deactivated")
	}
	
}

