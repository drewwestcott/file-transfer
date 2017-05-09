//
//  InterfaceController.swift
//  file-transfer WatchKit Extension
//
//  Created by Drew Westcott on 08/05/2017.
//  Copyright © 2017 Drew Westcott. All rights reserved.
//

import WatchKit
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {
	
	@IBOutlet var group: WKInterfaceGroup!
	@IBOutlet var label: WKInterfaceLabel!
	var backgroundImage: UIImage?
	var destinationURLForFile: URL?
	
	private let session: WCSession? = WCSession.isSupported() ? WCSession.default() : nil

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
//		var urlPath = Bundle.main.path(forResource: "background", ofType: "jpg")
//		let url = URL(string: urlPath!)
//		backgroundImage = UIImage(contentsOfFile: urlPath!)
		if WCSession.isSupported() {
			session?.delegate = self
			session?.activate()
		}
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
		
		group.setBackgroundImage(backgroundImage)
		label.setHidden(false)
		let transfersWaiting = session?.outstandingFileTransfers
		print("Transfers: \(transfersWaiting?.count)")
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
	
	
	func session(_ session: WCSession, didReceive file: WCSessionFile) {
		
		print("Received File")
		let directoryLocation = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first
		print(directoryLocation)
		//		let saveLocation =
		
		let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
		let documentDirectoryPath: String = path[0]
		print(documentDirectoryPath)
		let fileManager = FileManager()
		destinationURLForFile = URL(fileURLWithPath: documentDirectoryPath.appendingFormat("/background.jpg"))
		
		if fileManager.fileExists(atPath: (destinationURLForFile?.path)!) {
			print("File already Downloaded")
			do {
				try fileManager.removeItem(at: destinationURLForFile!)
			} catch {
				print("could not delete")
			}
		} else {
			print("Moving file")
			do {
				try fileManager.moveItem(at: file.fileURL, to: destinationURLForFile!)
			} catch {
				print("Error!")
			}
		}
		
		DispatchQueue.main.async {
			self.label.setHidden(true)
			print("Dispatch main")
			//var urlPath = Bundle.main.path(forResource: "background", ofType: "jpg")
			let urlPath = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first
			print(urlPath!)
			let completePath = urlPath?.appendingPathComponent("background.jpg")
			print(completePath)
			let data = NSData(contentsOf: completePath!)
			let backgroundImage = UIImage(data: data as! Data)
			self.group.setBackgroundImage(backgroundImage)
		}

	}
	
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		print("Activated")
	}

	func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?) {
		
		print("Transfer didFinish")
	}
}
