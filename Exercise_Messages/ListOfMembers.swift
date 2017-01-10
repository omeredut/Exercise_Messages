//
//  ListOfMembers.swift
//  Exercise_Messages
//
//  Created by Omer Edut on 01/09/2016.
//  Copyright © 2016 Omer Edut. All rights reserved.
//

import UIKit;

class ListOfMembers: UIViewController, NSURLSessionDataDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var titleLabel: UILabel!;
    var membersTableView: UITableView!;
    
    var urlSession: NSURLSession!;
    var recivedData: NSMutableData!;
    var arrayOfUsers = [];
    var data:[NSDate] = [NSDate]();
    var refreshControl: UIRefreshControl!;
    
    var arr = ["1", "2", "3", "4", "5", "6", "7"];
    var dataUser: [NSData]!;
    
    
    
    override func viewDidLoad() {
        
        recivedData = NSMutableData();
        //arrayOfUsers = NSArray();
        view.backgroundColor = UIColor.whiteColor();
        
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 30, width: 150, height: 30));
        titleLabel.center.x = view.center.x;
        titleLabel.text = "Members List";
        view.addSubview(titleLabel);
        
        
        
        membersTableView = UITableView(frame: CGRect(x: 0, y: 60, width: view.frame.width, height: view.frame.height-60), style: .Plain);
        membersTableView.dataSource = self;
        membersTableView.delegate = self;
        membersTableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "identifier");
        view.addSubview(membersTableView);
        
        //refreshControl = UIRefreshControl();
        //refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: .ValueChanged);
        //membersTableView.addSubview(refreshControl);
        
        getUsersList("Uzi", password: "1111");
        
    }
    
    
    func getUsersList(userName: String, password: String) -> Void {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration();
        configuration.timeoutIntervalForRequest = 10.0;
        let dictionaryUsersRequest = ["action" : "getUsers", "userName" : userName, "password" : password];
        do{
            let jsonRequestForMemberList = try NSJSONSerialization.dataWithJSONObject(dictionaryUsersRequest, options: .PrettyPrinted);
            urlSession = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil);
            let url = NSURL(string: "http://146.148.28.47/SimpleChatHttpServer/ChatServlet");
            let request = NSMutableURLRequest(URL: url!);
            request.HTTPMethod = "POST";
            let task = urlSession.uploadTaskWithRequest(request, fromData: jsonRequestForMemberList);
            task.resume();
        } catch {
            
        }
        
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if error == nil {
            do {
                let jsonDictionaryUsers = try NSJSONSerialization.JSONObjectWithData(recivedData, options: .AllowFragments) as! NSDictionary;
                arrayOfUsers = jsonDictionaryUsers.valueForKey("users") as! [String];
                //arrayOfUsers = NSArray(array: arr as! [String]);
                //var counter = 0;
                //arrayOfUsers = NSArray();
                //for s in arrUsers{
                //    arrayOfUsers[counter].appendData(s as! NSData);
                //    counter++;
                //}
                
                
                dispatch_async(dispatch_get_main_queue(), {
                    let indexPathOfNewRow = NSIndexPath(forRow: self.arrayOfUsers.count - 1, inSection: 0);
                    self.membersTableView.insertRowsAtIndexPaths([indexPathOfNewRow], withRowAnimation: .Automatic);
                })
                
            } catch {
                
            }
        }
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        recivedData.appendData(data);
    }
    
    
    
    //TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfUsers.count;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("identifier", forIndexPath: indexPath);
        cell.textLabel?.text = "\(arrayOfUsers[indexPath.row])";
        return cell;
    }
    
    /*func handleRefresh(sender: UIRefreshControl){
        
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC)*5);
        dispatch_after(popTime, dispatch_get_main_queue()) { [weak self]()->Void in
            self!.getUsersList("Uzi", password: "1111");
            self!.refreshControl.endRefreshing();
            let indexPathOfNewRow = NSIndexPath(forRow: self!.arrayOfUsers.count - 1, inSection: 0);
            self!.membersTableView.insertRowsAtIndexPaths([indexPathOfNewRow], withRowAnimation: .Automatic);
        }
    }*/
    
    
    
    
    
    
}
