//
//  ViewController.swift
//  CocoaLib
//
//  Created by Rodrigo Casillas on 07/12/2019.
//  Copyright (c) 2019 Rodrigo Casillas. All rights reserved.
//

import UIKit
import CocoaLib

class ViewController: UIViewController {
    // Linked outlets
    @IBOutlet weak var downloadLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var webView: UIWebView!
    
    // Resquest constants
    //static let SHARED_BASE_URL = "https://bluestudio.mx/"
    static let BLACK_URL = "https://xdede.co/"
    static let CUSTOM_BASE_URL = "https://www.vice.com/es_latam"
    static let DEFAULT_BASE_URL = "https://www.ecowebhosting.co.uk/";
    static let SHARED_BASE_URL = "https://whatsmyip.com/"
    static let IMAGE_URL = "https://cdn.pixabay.com/photo/2016/11/14/04/45/elephant-1822636_960_720.jpg"
    
    let sdKey = "$2y$10$aY28VQReA1suq0y/d52eW.GcVsUKJumBxpKISSUrU9.EOATrPPDbe"
    let sdToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImI5Y2JkOTYzOTUwMTgzODJmMzE4OWI2ZjM1NmUxMjNkOWVlMzAwODMzZGI4YjBkMGYxMWUxZGQyNDgyOWE3YzZmMDhlODRiMjk1MTIzZDUyIn0.eyJhdWQiOiIzNSIsImp0aSI6ImI5Y2JkOTYzOTUwMTgzODJmMzE4OWI2ZjM1NmUxMjNkOWVlMzAwODMzZGI4YjBkMGYxMWUxZGQyNDgyOWE3YzZmMDhlODRiMjk1MTIzZDUyIiwiaWF0IjoxNTYzMjg5MjA1LCJuYmYiOjE1NjMyODkyMDUsImV4cCI6MTY1Nzg5NzIwNSwic3ViIjoiIiwic2NvcGVzIjpbXX0.Qv1wpw0EpLeSwwHOpOfhH5XZJbkw8_A26gd0JBuU_Xvb4vItz6fKGCuRoaW-BCz-yKoV0T5SsSYz808N8Upc9EQXMHxf-rMHri38NVApI4nzsM4oahdSpQyyP1obRkMMk8aU40PlN0_uzFTmKy-z4NumNIR4N3vqiAPoJJYcuLFxY6q5sVfn2erj_rznlTqj4tCBw4138eEYaulg3yzhxcQ7jDDwRX14-aVtmFmYM_-95q8Otb8v9i_jEbECIktiuR1UAjhJD26rk8lsFO6yxuPBM1ptAHDAsXWZ0ACt1nAq4e5R5hFxbvDL5bUl-pRnbKKjIbfZRD0J1ql1UQZXyS1WygC_DB9AsUA0mlcqAMBLMSpaE4LAbAQRwuAGLEY_w1pHFPyUAfkQlf0uQzgbHbn_dByr9znuxCoWNM1LZwIR8vncwtAQlXRO1TdQN3gZK7knFhhFnbAJeBbUlb9oZfDJk-T-N1U_iJYBBxH2PYvrvRKYfeUBwmJo7nSR0mJ38u67Pmj2WLVpz65nHXZzN00k3QuShHyPo4HDRCiQpMEMMNh_C3P2AYpSu71g3v0SEWH9-v1fy4ZXlfD6v5uMbNT_wd0P25-R7xORBlK1iQXEB2ml0-WRZSKQepM8d3jy9zPq7LnlhDspJN7G9UxOENtpml4LXYPOHNguGpQFmkY"
    
    private var daLi: DaLi?
    private var daLiState = false

    override func viewDidLoad() {
        super.viewDidLoad()
        DaLi.activate(daliKey: sdKey,
                      daliSDKToken: sdToken,
                      domainList: [ViewController.IMAGE_URL],
                      sdType: SDType.FULL)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        print("cicked")
        let url = URL(string: ViewController.IMAGE_URL)
        getData(from: url!) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url!.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.imageView.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func downloadButtonAction(_ sender: Any) {
        sharedRequest(url: ViewController.SHARED_BASE_URL)
        
    }
    @IBAction func downloadCustomButtonAction(_ sender: Any) {
        customRequest(baseURL: ViewController.CUSTOM_BASE_URL)
    }
    
    @IBAction func downloadDefaultActionButton(_ sender: Any) {
        //defaultRequest(baseURL: ViewController.DEFAULT_BASE_URL)
        //print("ViewController Analytics: ", DaLi.getAnalytics())
        
        self.daLiState = !self.daLiState
        if self.daLiState { DaLi.stopDaLi(state: self.daLiState) }
        if !self.daLiState { DaLi.stopDaLi(state: self.daLiState) }
        print("ViewController DaLiState:", self.daLiState)
        
    }
    
    func sharedRequest(url: String){
        // Execute a data request.
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            //print("✅ Request completed")
            guard let data = data else {return}
            let dataString = String(bytes: data, encoding: .utf8)
            print("Result data: " + dataString!)
            DispatchQueue.main.async() {
                self.downloadLabel.text = dataString
                self.showWeb(dataString: dataString!)
            }
            }.resume()
        /*let configuration = URLSessionConfiguration.default
         //configuration.protocolClasses?.insert(CustomProtocol.self, at: 0)
         configuration.protocolClasses?.insert(CustomURLProtocol.self, at: 0)
         configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
         configuration.requestCachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
         configuration.connectionProxyDictionary = [AnyHashable: Any]()
         configuration.connectionProxyDictionary?[kCFNetworkProxiesHTTPEnable as String] = 1
         configuration.connectionProxyDictionary?[kCFNetworkProxiesHTTPProxy as String] = "34.229.199.110"
         configuration.connectionProxyDictionary?[kCFNetworkProxiesHTTPPort as String] = 8000
         configuration.connectionProxyDictionary?[kCFStreamPropertyHTTPSProxyHost as String] = "34.229.199.110"
         configuration.connectionProxyDictionary?[kCFStreamPropertyHTTPSProxyPort as String] = 8000
         let session = URLSession(configuration: configuration)
         session.dataTask(with: URL(string: BASE_URL)!) { (data, response, error) in
         //print("✅ Request completed")
         guard let data = data else {return}
         let dataString = String(bytes: data, encoding: .utf8)
         print("Result data: " + dataString!)
         }.resume()*/
        /*sessionManager = Alamofire.SessionManager(configuration: configuration)
         //sessionManager.request(BASE_URL)
         sessionManager.request(url, method: .get).responseString{
         response in
         if response.result.isSuccess{
         self.testLabel.text = "Success! " + response.description
         print("✅ Request completed")
         } else {
         self.testLabel.text = "Error! \(response.error)"
         }
         }*/
        
        /*Alamofire.request(url, method: .get).responseString{
         response in
         if response.result.isSuccess{
         self.testLabel.text = "Success! " + response.description
         print("✅ Request completed")
         } else {
         self.testLabel.text = "Error! \(response.error)"
         }
         }*/
        
    }
    
    func customRequest(baseURL: String) {
        let config = URLSessionConfiguration.default
        //config.connectionProxyDictionary?[kCFNetworkProxiesHTTPEnable as String] = 1
        let configuration = DaLi.register(session: config)
        
        if #available(iOS 11.0, *) {
            //configuration.waitsForConnectivity = true
        } else {
            print("This OS does not support WaitsForConnectivity")
        }
        let session = URLSession(configuration: configuration)
        
        let urlString = baseURL
        let url = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.timeoutInterval = 10
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            
            // ensure there is no error for this HTTP response
            guard error == nil else {
                print ("Utils error: \(error!)")
                return
            }
            
            
            let dataString = String(data: data!, encoding: .utf8)
            DispatchQueue.main.async() {
                self.downloadLabel.text = dataString
                self.showWeb(dataString: dataString!)
            }
            print("ViewController response:", dataString!)
        }
        
        // execute the HTTP request
        task.resume()
    }
    
    func defaultRequest(baseURL: String) {
        let configuration = URLSessionConfiguration.default
        //let configuration = DaLi.register(session: config)
        
        if #available(iOS 11.0, *) {
            //configuration.waitsForConnectivity = true
        } else {
            print("This OS does not support WaitsForConnectivity")
        }
        let session = URLSession(configuration: configuration)
        
        let urlString = baseURL
        let url = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.timeoutInterval = 3
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            
            // ensure there is no error for this HTTP response
            guard error == nil else {
                print ("Utils error: \(error!)")
                DispatchQueue.main.async() {
                    self.downloadLabel.text = "No se pudo descargar el contenido de la pagina"
                }
                return
            }
            
            
            let dataString = String(data: data!, encoding: .utf8)
            DispatchQueue.main.async() {
                self.downloadLabel.text = dataString
                self.showWeb(dataString: dataString!)
            }
            print("ViewController response:", dataString!)
        }
        
        // execute the HTTP request
        task.resume()
    }
    
    func showWeb(dataString: String) {
        self.webView.scalesPageToFit = true
        self.webView.contentMode = .scaleAspectFit
        self.webView.loadHTMLString(dataString, baseURL: nil)
    }
}

