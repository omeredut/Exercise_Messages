//
//  ViewController.swift
//  Exercise_Messages
//
//  Created by Omer Edut on 01/09/2016.
//  Copyright © 2016 Omer Edut. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NSURLSessionDataDelegate {
    
    let logIn: Int = 1;
    let signUp: Int = 2;
    
    var memberList: UIViewController!;
    
    var userNameTextField: UITextField!;
    var passwordTextField: UITextField!;
    var btnSignUp: UIButton!;
    var btnLogIn: UIButton!;
    
    var textFieldWidth: CGFloat = 200;
    var textFieldHeight: CGFloat = 30;
    
    var userName: String = "";
    var password: String = "";
    
    
    
    var urlSession: NSURLSession!;
    var recivedData: NSMutableData!;
    

    override func viewDidLoad() {
        super.viewDidLoad();
        
        recivedData = NSMutableData();
        
        userNameTextField = UITextField(frame: CGRect(x: 0, y: 30, width: textFieldWidth, height: textFieldHeight));
        userNameTextField.center.x = view.center.x;
        userNameTextField.placeholder = "Enter Your User Name";
        view.addSubview(userNameTextField);
        
        passwordTextField = UITextField(frame: CGRect(x: 0, y: 60, width: textFieldWidth, height: textFieldHeight));
        passwordTextField.center.x = view.center.x;
        passwordTextField.placeholder = "Enter your password";
        view.addSubview(passwordTextField);
        
        btnLogIn = UIButton(type: .System);
        btnLogIn.frame = CGRect(x: 0, y: 90, width: textFieldWidth, height: textFieldHeight);
        btnLogIn.center.x = view.center.x;
        btnLogIn.setTitle("Log In", forState: .Normal);
        btnLogIn.addTarget(self, action: "handleLogIn:", forControlEvents: .TouchUpInside);
        view.addSubview(btnLogIn);
        
        btnSignUp = UIButton(type: .System);
        btnSignUp.frame = CGRect(x: 0, y: 120, width: textFieldWidth, height: textFieldHeight);
        btnSignUp.center.x = view.center.x;
        btnSignUp.setTitle("Sign Up", forState: .Normal);
        btnSignUp.addTarget(self, action: "handleSignUp:", forControlEvents: .TouchUpInside);
        view.addSubview(btnSignUp);
    }
    
    
    func handleLogIn(logInSender: UIButton) {
        checkMessage("login", userName: userNameTextField.text!, password: passwordTextField.text!, message: nil);
    }

    func handleSignUp(signUpSender: UIButton) {
        checkMessage("signup", userName: userNameTextField.text!, password: passwordTextField.text!, message: nil);
    }
    
    
    func checkMessage(action: String, userName: String, password: String, message: String?) -> Void {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration();
        configuration.timeoutIntervalForRequest = 10.0;
        
        //if action == "getMessage" {
        //    var userDictionary = ["action" : action, "userName" : userName, "password" : password, "message" : message];
        //} else {
            let userDictionary = ["action" : action, "userName" : userName, "password" : password];
        //}
        
        do {
            let jasonData = try NSJSONSerialization.dataWithJSONObject(userDictionary, options: .PrettyPrinted);
            urlSession = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil);
            let url = NSURL(string: "http://146.148.28.47/SimpleChatHttpServer/ChatServlet");
            let request = NSMutableURLRequest(URL: url!);
            request.HTTPMethod = "POST";
            let task = urlSession.uploadTaskWithRequest(request, fromData: jasonData);
            task.resume();
        } catch {
            
        }
    }
    
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        
        if error == nil {
            
            do {
                let responseDictionary = try NSJSONSerialization.JSONObjectWithData(recivedData, options: .AllowFragments) as! NSDictionary;
                let responseResult: String = String(responseDictionary.valueForKey("result")!);
                print(responseResult);
                
                dispatch_sync(dispatch_get_main_queue(), { 
                    if responseResult == "success" {
                        if self.memberList == nil {
                            self.memberList = ListOfMembers();
                        }
                        self.presentViewController(self.memberList, animated: true, completion: nil);
                        
                    } else {
                        return;
                    }
                });
                
                
                
            } catch {
                
            }
        }
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        recivedData.setData(data);
    }
    
    
    
}

