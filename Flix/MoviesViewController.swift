//
//  MoviesViewController.swift
//  Flix
//
//  Created by Luis Mora on 2/5/22.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    

    /*these variables are called properties and they are going to last for the lifetime of that screen
     movies is an array of dictionaries(hash), type of key and type of value, parethesis means a creation of something
     */
    @IBOutlet weak var tableView: UITableView!
    
    var movies = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                 
                 //movies look at the data dictionaries and get oout results, by looking at the key "results: and looking at the type dictionaries(casting)
                 self.movies = dataDictionary["results"] as! [[String: Any]]
                 
                 self.tableView.reloadData()

             }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //dequeuReusableCell lets us recycle off screen cells or creat new cells
        //as! MovieCell tells us "MovieCell" is of type MovieCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        //storing movie at the row
        let movie = movies[indexPath.row]
        //as! String, tells that the key "title" is a string value which we saw in the API
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        
        cell.synopsisLabel.text = synopsis
        cell.titleLabel.text = title
        
        //from looking at the API we need 3 things: base_URL, file_size(specified at the end of the base URL), and file_path
        let baseURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseURL + posterPath)
        
        //.af_setImage was imported with AlamofireImage library that takes care of downloading and setting the image
        cell.posterView.af.setImage(withURL: posterUrl!)
        
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        print("loading up the details screen")
        
        // Find the selected movie
        let cell = sender as! UITableViewCell //the sender is actually the UITableView cell
        let indexPath = tableView.indexPath(for: cell)! // table view knows for a given cell what the indexPath is
        let movie = movies[indexPath.row] //the movie is the indexPath in the movies array
        
        // Pass the selected movie tot the details view controller
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie
        
        //deselecting the selected movie
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
