import UIKit
import StoreKit

//let indicates a constant that cannot be changed. var would be changeable.
let secondViewController:SKStoreProductViewController = SKStoreProductViewController()

class ViewController: UIViewController,SKStoreProductViewControllerDelegate {
    
    //override 
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func BuySomething(sender : AnyObject) {
        
    println("in buy something function")
        
        secondViewController.delegate = self
        
        var someitunesid:String = "963996539"
        
        var productparameters = [SKStoreProductParameterITunesItemIdentifier:963996539]
       
    println("after product parameters")
        
        
        secondViewController.loadProductWithParameters(productparameters, {
            (success: Bool!,error: NSError!) -> Void in
            println("in 2nd view controller")
            
            if success != nil {
                NSLog("%@",success)
                self.presentViewController(secondViewController, animated: true, completion: nil)
                
                
                println("animate 2nd view control")

            } else {
                NSLog("%@", error)
            }
            })
        println("Last line")
    }
    
    // this is SKStoreProductViewControllerDelegate implementation
    //implicitly unwrapped) optional closure (() -> Void)!
    
    func productViewControllerDidFinish(viewController: SKStoreProductViewController!) {
        
      secondViewController.dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    //Server side
    func validateRecipt(){
        var response: NSURLResponse?
        var error: NSError?
        
        var recuptUrl = NSBundle.mainBundle().appStoreReceiptURL
        var receipt: NSData = NSData(contentsOfURL:recuptUrl!, options: nil, error: nil)!
        
        var receiptdata:NSString = receipt.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.allZeros)
        
        NSLog("%@",receiptdata)
        
        var request = NSMutableURLRequest(URL: NSURL(string: "http://yourdomain.com/write.php")!)
        
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var err: NSError?
        
        request.HTTPBody = receiptdata.dataUsingEncoding(NSASCIIStringEncoding)
        
        var task = session.dataTaskWithRequest(request, completionHandler:
            {data, response, error -> Void in
                var err: NSError?
                var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
                
                if(err != nil) {
                    println(err!.localizedDescription)
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: '\(jsonStr)'")
                }
                else {
                    if let parseJSON = json {
                        println("Recipt \(parseJSON)")
                    }
                    else {
                        let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                        println("Recipt Error: \(jsonStr)")
                    }
                }
        })
        
        task.resume()
        
    }
    
}
