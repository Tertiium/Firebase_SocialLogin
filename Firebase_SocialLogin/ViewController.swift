//
//  ViewController.swift
//  Firebase_SocialLogin
//
//  Created by user on 16/02/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import TwitterKit

class ViewController: UIViewController{

    // MARK: - Outlets
    
    // MARK: - Properties
    var twitterButton = TWTRLogInButton()
    var googleButton = GIDSignInButton()
    var customButton = UIButton()
    var loginButton = FBSDKLoginButton()
    var customFBButton = UIButton()
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFacebookButtons()
        
        setupGoogleButtons()
        
        setupTwitterButtons()
        
        setupConstraints()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    func handleCustomGoogleSignIn(){
        GIDSignIn.sharedInstance().signIn()
    }
    
    func handleCustomLoginButton(){
        FBSDKLoginManager().logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("FB Cutom Login Fail: \(error)")
                return
            }
            self.showEmailAddress()
        }
    }
    
    // MARK: - Functions
    
    func setupConstraints(){
        let dicionarioButtons = ["button1":loginButton,"button2":customFBButton,"button3":googleButton,"button4":customButton,"button5":twitterButton] as [String : Any]
     
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        customFBButton.translatesAutoresizingMaskIntoConstraints = false
        googleButton.translatesAutoresizingMaskIntoConstraints = false
        customButton.translatesAutoresizingMaskIntoConstraints = false
        twitterButton.translatesAutoresizingMaskIntoConstraints = false
        
        //
        let button1HeightConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:[button1(50)]", options: NSLayoutFormatOptions(), metrics: nil, views: dicionarioButtons)
        let contraintPosicaoXButton1 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[button1]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: dicionarioButtons)
        let contraintPosicaoYButton1 = NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[button1]|", options: NSLayoutFormatOptions(), metrics: nil, views: dicionarioButtons)
        self.view.addConstraints(button1HeightConstraint)
        self.view.addConstraints(contraintPosicaoXButton1)
        self.view.addConstraints(contraintPosicaoYButton1)
        
        //
        let button2HeightConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:[button2(==button1)]", options: NSLayoutFormatOptions(), metrics: nil, views: dicionarioButtons)
        let contraintPosicaoXButton2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[button2]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: dicionarioButtons)
        let contraintPosicaoYButton2 = NSLayoutConstraint.constraints(withVisualFormat: "V:[button1]-30-[button2]", options: NSLayoutFormatOptions(), metrics: nil, views: dicionarioButtons)
        self.view.addConstraints(button2HeightConstraint)
        self.view.addConstraints(contraintPosicaoXButton2)
        self.view.addConstraints(contraintPosicaoYButton2)
        
        //
        let button3HeightConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:[button3(==button1)]", options: NSLayoutFormatOptions(), metrics: nil, views: dicionarioButtons)
        let contraintPosicaoXButton3 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[button3]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: dicionarioButtons)
        let contraintPosicaoYButton3 = NSLayoutConstraint.constraints(withVisualFormat: "V:[button2]-30-[button3]", options: NSLayoutFormatOptions(), metrics: nil, views: dicionarioButtons)
        self.view.addConstraints(button3HeightConstraint)
        self.view.addConstraints(contraintPosicaoXButton3)
        self.view.addConstraints(contraintPosicaoYButton3)
        
        //
        let button4HeightConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:[button4(==button1)]", options: NSLayoutFormatOptions(), metrics: nil, views: dicionarioButtons)
        let contraintPosicaoXButton4 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[button4]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: dicionarioButtons)
        let contraintPosicaoYButton4 = NSLayoutConstraint.constraints(withVisualFormat: "V:[button3]-30-[button4]", options: NSLayoutFormatOptions(), metrics: nil, views: dicionarioButtons)
        self.view.addConstraints(button4HeightConstraint)
        self.view.addConstraints(contraintPosicaoXButton4)
        self.view.addConstraints(contraintPosicaoYButton4)
        
        //
        let button5HeightConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:[button5(==button1)]", options: NSLayoutFormatOptions(), metrics: nil, views: dicionarioButtons)
        let contraintPosicaoXButton5 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[button5]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: dicionarioButtons)
        let contraintPosicaoYButton5 = NSLayoutConstraint.constraints(withVisualFormat: "V:[button4]-30-[button5]", options: NSLayoutFormatOptions(), metrics: nil, views: dicionarioButtons)
        self.view.addConstraints(button5HeightConstraint)
        self.view.addConstraints(contraintPosicaoXButton5)
        self.view.addConstraints(contraintPosicaoYButton5)
    }
    
    fileprivate func setupTwitterButtons(){
        twitterButton = TWTRLogInButton { (session, err) in
            if err != nil{
                print("Failed to login via Twitter: \(err)")
                return
            }
            
            //print("Successfully logged in under Twitter")
            
            //lets login with Firebase
            guard let token = session?.authToken else { return }
            guard let secret = session?.authTokenSecret else { return }
            let credentials = FIRTwitterAuthProvider.credential(withToken: token, secret: secret)
            FIRAuth.auth()?.signIn(with: credentials, completion: { (user, err) in
                
                if err != nil {
                    print("Failed to login to Firebase with Twitter: \(err)")
                    return
                }
                
                print("Successfully created a Firebase-Twitter user: \(user?.uid ?? "")")
                
                self.showTwiiter()
                
            })
    
        }
        
        self.view.addSubview(twitterButton)
    }
    
    func showTwiiter(){

        let client = TWTRAPIClient.withCurrentUser()
        let request = client.urlRequest(withMethod: "GET",
                                        url: "https://api.twitter.com/1.1/account/verify_credentials.json",
                                        parameters: ["include_email": "true", "skip_status": "true"],
                                        error: nil)
        
        client.sendTwitterRequest(request, completion: { (response, data, error) in
            if let err = error{
                print("\(err)")
                return
            }
            print(data!)
            // Não conseguir pegar email do Twitter
//            if let dataTemp = data{
//                var dicionario : [String : Any] = [:]
//                do{
//                    dicionario = try JSONSerialization.jsonObject(with: dataTemp, options: .allowFragments) as! [String : String]
//                    print(dicionario)
//                }catch{
//                    print("FATALLLL")
//                }
//            }
        })
        
    }
    
    
    fileprivate func setupGoogleButtons(){
        // add Google sign in button
        googleButton = GIDSignInButton()
        self.view.addSubview(googleButton)
        
        // Custom Button
        customButton = UIButton()
        self.view.addSubview(customButton)
        customButton.backgroundColor = UIColor.orange
        customButton.setTitle("Custom Google Sign In", for: .normal)
        customButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        customButton.addTarget(self, action: #selector(self.handleCustomGoogleSignIn), for: .touchUpInside)
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        
    }
    
    fileprivate func setupFacebookButtons(){
        // add Facebook Login Button
        loginButton = FBSDKLoginButton()
        self.view.addSubview(loginButton)
        loginButton.delegate = self
        loginButton.readPermissions = ["email","public_profile"]
        
        // add our custom fb login button here
        customFBButton = UIButton()
        customFBButton.backgroundColor = UIColor(red:0.23, green:0.35, blue:0.60, alpha:1.0)
        customFBButton.setTitle("Custom FB Login here", for: .normal)
        customFBButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        self.view.addSubview(customFBButton)
        customFBButton.addTarget(self, action: #selector(self.handleCustomLoginButton), for: .touchUpInside)
        
    }
    
    func showEmailAddress(){
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil{
                print("Something went wrong  with our FB user: \(error)")
                return
            }
            print("Successfully logged in with our user: \(user)")
        })
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"id, name, email"]).start { (connection, result, err) in
            
            if err != nil{
                print("Failed to start graph request: \(err)")
                return
            }
            
            print(result!)
        }
    }
    
}

// Delegate do GoogleLoginButton

extension ViewController: GIDSignInUIDelegate{
    
}

// Delegate do FBSDKLoginButton

extension ViewController: FBSDKLoginButtonDelegate{
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        print("Successfully logged in with facebook...")
        self.showEmailAddress()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    
    
}


