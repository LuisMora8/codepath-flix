//
//  MovieWebTrailerViewController.swift
//  Flix
//
//  Created by Luis Mora on 2/11/22.
//

import UIKit
import WebKit

class MovieWebTrailerViewController: UIViewController, WKUIDelegate {

    var webView: WKWebView!
    
    var movie: [String:Any]!
    
    var videos = [[String: Any]]()
    
    override func loadView() {
            let webConfiguration = WKWebViewConfiguration()
            webView = WKWebView(frame: .zero, configuration: webConfiguration)
            webView.uiDelegate = self
            view = webView
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //URL request API key of the movie's videos
        let baseURL = "https://api.themoviedb.org/3/movie/"
        let movieID = movie["id"] as! Int
        let url = URL(string: baseURL + String(movieID) + "/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US")
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                 
                 //save the dictionary into the array of videos
                 self.videos = dataDictionary["results"] as! [[String: Any]]
                 
                 //loading video URL from first trailer in dictionary results
                 let trailerKey = self.videos[0]["key"] as! String
                 let videoUrl = URL(string: "https://www.youtube.com/watch?v=" + trailerKey)
                 let videoRequest = URLRequest(url: videoUrl!)
                 self.webView.load(videoRequest)
             }
        }
        task.resume()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
