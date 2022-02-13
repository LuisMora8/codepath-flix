//
//  MovieGridViewController.swift
//  Flix
//
//  Created by Luis Mora on 2/11/22.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var movies = [[String:Any]]()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //using default lauyout for the collection view
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        //controls the line spacing in between the rows by pixels
        layout.minimumLineSpacing = 4
        //created minimum spacing between cells
        layout.minimumInteritemSpacing = 4
        
        //width will change by the width of the users phone, 3 cells per phone, minues the interitemspacing to fit cells with spacing
        let width = (view.frame.size.width - layout.minimumInteritemSpacing * 2) / 3
        layout.itemSize = CGSize(width: width, height: width * 3 / 2)
        
        
        //API code for similar movies
        let url = URL(string: "https://api.themoviedb.org/3/movie/634649/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
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
                 
                 //after loading page, reload data to display data
                 self.collectionView.reloadData()
                 print(self.movies)

             }
        }
        task.resume()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        
        let movie = movies[indexPath.item]
        
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
        
        //Find the selected movie
        let cell = sender as! UICollectionViewCell
        
        let indexPath = collectionView.indexPath(for: cell)
        
        let movie = movies[indexPath!.row]
        
        //Pass the selected movie to the details view controller
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie
    }
    

}
