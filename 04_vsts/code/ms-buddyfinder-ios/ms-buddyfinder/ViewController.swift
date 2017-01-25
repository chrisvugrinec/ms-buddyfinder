//
//  ViewController.swift
//
//  Created by chris vugrinec on 24-12-16.
//  Copyright © 2016 datalinks. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation
import UserNotifications


class ViewController: UIViewController, CLLocationManagerDelegate {


    let locManager = CLLocationManager()
    var uuid = UUID().uuidString
    let max_counter = 2
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    var updateTimer: Timer?
    var userName: String?
    
    @IBOutlet weak var useridField: UITextField!
    @IBOutlet weak var beacondIdField: UITextField!
    @IBOutlet weak var shoutField: UITextField!
    @IBOutlet weak var imageView1: UIImageView!
    var csaImage = UIImage(named:"csa.png")
    var lunchImage = UIImage(named:"lunch.png")
    var coffeeImage = UIImage(named:"coffee.png")
    
    let trigger = UNPushNotificationTrigger.self
    let notif = UNMutableNotificationContent()
    
    
    
    enum STATE : String {
        case UNKNOWN = "unknown"
        case IN_NEAR = "in_near"
        case IN_IMMEDIATE = "in_immediate"
        case OUT = "in_out"
    }
    enum BEACON : String {
        case LUNCH = "lunch"
        case COFFEE = "coffee"
        case CSA = "csa"
    }

    var currentStatus: STATE = STATE.UNKNOWN
    var unknownCounter = 0
    var farCounter = 0
    var nearCounter = 0
    var immediateCounter = 0
    var strongestBeaconCounter = 0
    var sameRssiCounter = 0
    
    
    
    
    @IBAction func shoutPressed(_ sender: UIButton) {
        callRestBroadcast(from: useridField.text!,message: shoutField.text!)
    }
    
    
    @IBAction func activateNamePressed(_ sender: UIButton) {
        print("You clicked the setName button!!!!! "+useridField.text!)
        UserDefaults.standard.set(useridField.text, forKey: "USER")
        userName = useridField.text
        view.endEditing(true)
    }

    @IBAction func hidePressed(_ sender: UIButton) {
        print("You clicked the Hide button!!!!! ")
        UserDefaults.standard.set(useridField.text, forKey: "USER")
        userName = useridField.text
        view.endEditing(true)
        cleanup()
    }

    
    
    func applicationWillTerminate(application: UIApplication) {
        print("terminating app")
        cleanup()
    }
    
    
    //  Used for initialization
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        //  Setting UUID
        if(UserDefaults.standard.object(forKey: "UUID") == nil){
            print("uuid was null ...setting new one")
            UserDefaults.standard.set(uuid, forKey: "UUID")
        }else{
            uuid = (UserDefaults.standard.object(forKey: "UUID") as? String)!
        }

        //  Setting USER
        if(UserDefaults.standard.object(forKey: "USER") != nil){
            useridField.text = UserDefaults.standard.object(forKey: "USER") as? String
        }else {
            useridField.placeholder = "username"
            UserDefaults.standard.set("username", forKey: "USER")
        }
        
        userName =  UserDefaults.standard.object(forKey: "USER") as? String
        locManager.delegate = self
        
        
        if(CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse){
            locManager.requestWhenInUseAuthorization()
        }
        
        //  Background job
        NotificationCenter.default.addObserver(self, selector: #selector(reinstateBackgroundTask), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        registerBackgroundTask()
        
        Timer.scheduledTimer(timeInterval: 3.0, target: self,selector: #selector(testBackgroundJob), userInfo: nil, repeats: true)
        
        
        notif.title = "new notif"
        notif.subtitle = "sub"
        notif.body = "hello world"
        
        
        //let request = UNNotificationRequest(identifier: "aps", content: notif, trigger: trigger)
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }


    

    func setCounter(state : STATE){

        switch state {
            case .UNKNOWN:
                unknownCounter+=1
                farCounter = 0
                nearCounter = 0
                immediateCounter = 0
            case .OUT:
                unknownCounter=0
                farCounter += 1
                nearCounter = 0
                immediateCounter = 0
            case .IN_NEAR:
                unknownCounter=0
                farCounter = 0
                nearCounter += 1
                immediateCounter = 0
            case .IN_IMMEDIATE:
                unknownCounter=0
                farCounter = 0
                nearCounter = 0
                immediateCounter += 1
        }
    }
    
    func resetAllCounters(){
        unknownCounter=0
        farCounter = 0
        nearCounter = 0
        immediateCounter = 0
    }
    

    
    // 1 = uuid , 2 = user , 3 = beacon , 4 = state
    func callRestState(uuid: String, user: String, _beacon: BEACON, state: STATE){
        
        //  Setting the current state within app
        self.currentStatus = state
        
        //  Resetting counters
        resetAllCounters()
        
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let host = "https://msbf.datalinks.nl:3000/in?"
        let params  = "uuid="+uuid+"&user="+user+"&beacon="+_beacon.rawValue+"&state="+state.rawValue;
        
        
        let escapedString = params.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let compiledUrl = host+escapedString!
        let url = URL(string: compiledUrl)!

        session.dataTask(with: url, completionHandler: {
            (data, response, error) in
                print("do rest call for uuid "+uuid+" beacon "+_beacon.rawValue+" action "+state.rawValue)
        }).resume()
        
    }
    
 
    // 1 = from , 2 = message
    func callRestBroadcast(from: String, message: String){
        
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let host = "https://msbf.datalinks.nl:3000/broadcast?"
        let params  = "from="+from+"&message="+message;
        
        let escapedString = params.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let compiledUrl = host+escapedString!
        let url = URL(string: compiledUrl)!
        
        session.dataTask(with: url, completionHandler: {
            (data, response, error) in
        }).resume()
        
    }
    
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func reinstateBackgroundTask() {
        if updateTimer != nil && (backgroundTask == UIBackgroundTaskInvalid) {
            registerBackgroundTask()
        }
    }
    
    func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        testBackgroundJob()
        assert(backgroundTask != UIBackgroundTaskInvalid)
    }
    

    func cleanup(){
        //  If APP Ends...remove user from overview (PASSING SOME BEACON and UNKNOWN STATE)
        if(self.currentStatus != STATE.UNKNOWN){
            print("unknowncounter (grey) "+String(describing: self.unknownCounter))
            self.view.backgroundColor = UIColor.gray
            self.callRestState(uuid: self.uuid,user: self.userName!,_beacon: BEACON.CSA,state: STATE.UNKNOWN)
            self.setCounter(state: STATE.UNKNOWN)
        }
    }
    
    
    func endBackgroundTask() {
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskInvalid
        print("Background task ended, removing uuid: "+self.uuid)
        cleanup()
    }
    
    func testBackgroundJob(){
            switch UIApplication.shared.applicationState {
            case .inactive:
                print("inactive background job...")
            default:
                break
            }

    }
    
    func startScanning() {
//        let uuid = UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!
        let uuid = UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")!

        
        let region = CLBeaconRegion(proximityUUID: uuid, identifier: "pflocator-")

        locManager.startMonitoring(for: region)
        locManager.startRangingBeacons(in: region)
        print("start scanning")
    }

  
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
    }
    

    func updateDistance(_beacon: BEACON,_ distance: CLProximity) {
        UIView.animate(withDuration: 0.8) {
            switch distance {
            case .far:
                print("farcounter (blue) "+String(describing: self.farCounter))
                self.view.backgroundColor = UIColor.blue
                if(self.currentStatus != STATE.OUT && self.farCounter>=self.max_counter){
                    self.callRestState(uuid: self.uuid,user: self.userName!,_beacon: _beacon,state: STATE.OUT)
                }
                self.setCounter(state: STATE.OUT)
            case .near:
                print("nearcounter (orange) "+String(describing: self.nearCounter))
                self.view.backgroundColor = UIColor.orange
                if(self.currentStatus != STATE.IN_NEAR && self.nearCounter>=self.max_counter){
                    self.callRestState(uuid: self.uuid,user: self.userName!,_beacon: _beacon,state: STATE.IN_NEAR)
                }
                self.setCounter(state: STATE.IN_NEAR)
            case .immediate:
                print("redhotounter (red) "+String(describing: self.immediateCounter))
                self.view.backgroundColor = UIColor.red
                if(self.currentStatus != STATE.IN_IMMEDIATE && self.immediateCounter>=self.max_counter){
                    self.callRestState(uuid: self.uuid,user: self.userName!,_beacon: _beacon,state: STATE.IN_IMMEDIATE)
                }
                self.setCounter(state: STATE.IN_IMMEDIATE)
            default:
                self.cleanup()
                break
            }
        }
    }
    
  
    //  Master looper...
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        //  13382 = CSA, 13424 = LUNCH, 12994 = COFFEE
        //let dbBeacons: [NSNumber] = [ 13382,13424,12994 ];
        let dbBeacons: [NSNumber] = [ 5042,13424,12994 ];

        let knownBeacons = beacons.filter{ dbBeacons.contains($0.major) }

        var strongestBeacon : CLBeacon?
        var signalStrenght = -100;
        
        //  Determine which beacon has the strongest signal
        for beacon in knownBeacons {
            //print("beacon "+String(describing: beacon.major)+" strength "+String(describing: beacon.rssi)+" proximity: ")
            if((beacon.rssi>signalStrenght) && (beacon.proximity != CLProximity.unknown)){
                
                signalStrenght=beacon.rssi
                strongestBeacon = beacon
            }
            if(strongestBeacon?.major==beacon.major){
                strongestBeaconCounter += 1
            }
            //  SIGN that beacon is not in proximity anywhere RSSI stays the same
            if(beacon.proximity == CLProximity.unknown && beacon.rssi==0){
                sameRssiCounter += 1
            }
        }

        //  If the RSSI for the strongestbeacon hasn't changed after 3 x measures then it can be removed
        if(sameRssiCounter>10){
            cleanup()
            sameRssiCounter=0
        }else{
            if(strongestBeacon?.major==5042){
                updateDistance(_beacon: BEACON.CSA,(strongestBeacon?.proximity)!)
                beacondIdField.text = BEACON.CSA.rawValue
                imageView1.image = csaImage
            }
/*
            if(strongestBeacon?.major==13382){
                updateDistance(_beacon: BEACON.CSA,(strongestBeacon?.proximity)!)
                beacondIdField.text = BEACON.CSA.rawValue
                imageView1.image = csaImage
            }
 */
            if(strongestBeacon?.major==12994){
                updateDistance(_beacon: BEACON.COFFEE,(strongestBeacon?.proximity)!)
                beacondIdField.text = BEACON.COFFEE.rawValue
                imageView1.image = coffeeImage
            }
            if(strongestBeacon?.major==13424){
                updateDistance(_beacon: BEACON.LUNCH,(strongestBeacon?.proximity)!)
                beacondIdField.text = BEACON.LUNCH.rawValue
                imageView1.image = lunchImage
            }
        }
        strongestBeaconCounter=0
        
    }
    
}

