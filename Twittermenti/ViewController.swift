import UIKit
import CoreML
import SwifteriOS
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    
    let countOfTweets = 100
    
    let sentimentClasifate = TweetSentimentClassifier()
    
    let swifter = Swifter(consumerKey: "yep_no_key", consumerSecret: "Just_clear")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func predictPressed(_ sender: Any) {
        
        fetchTweets()
        
    }
    
    func fetchTweets() {
        
        if let searchField = textField.text {
            
            swifter.searchTweet(using: searchField, lang: "en", count: countOfTweets, tweetMode: .extended, success: { (results, metadata) in
                
                var tweets = [TweetSentimentClassifierInput]()
                
                for i in 0..<self.countOfTweets {
                    if let tweet = results[i]["full_text"].string{
                        let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
                        tweets.append(tweetForClassification)
                    }
                }
                print(tweets.count)
                
                self.makePredeiction(with: tweets)
                
            }){ (error) in
                print("There was an error with Twitter API request:\(error)")
            }
        }
        
    }
    
    func makePredeiction(with tweets: [TweetSentimentClassifierInput]) {
        do{
            
            let predictions = try self.sentimentClasifate.predictions(inputs: tweets)
            
            var sentimentScore = 0
            
            for prediction in predictions {
                let sentiment = prediction.label
                if sentiment == "Neg" {
                    sentimentScore -= 1
                } else if sentiment == "Pos"{
                    sentimentScore += 1
                }
                
            }
            
            updateUI(with: sentimentScore)
            
        } catch {
            print("There was an error with making predicatoion\(error)")
        }
        
    }
    
    func updateUI(with sentimentScore: Int) {
        
        if sentimentScore > 20 {
            self.sentimentLabel.text = "😍"
        } else if sentimentScore > 10 {
            self.sentimentLabel.text = "😁"
        } else if sentimentScore > 0 {
            self.sentimentLabel.text = "😐"
        } else if sentimentScore > -10 {
            self.sentimentLabel.text = "🥴"
        } else if sentimentScore > -20 {
            self.sentimentLabel.text = "🤬"
        } else {
            self.sentimentLabel.text = "💩"
        }
        
    }
    
}

