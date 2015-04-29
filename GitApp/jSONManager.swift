//
//  jSONManager.swift
//  GitApp
//
//  Created by Felipe Marques Ramos on 29/04/15.
//  Copyright (c) 2015 Felipe Marques Ramos. All rights reserved.
//

import UIKit

class jSONManager: NSObject {
    
    var dm: DataManager = DataManager.sharedInstance
    
    func buscarRepos(user:String!){
        let clientID = "8fb09c4abdef8660c7a4"
        let clientSecret = "562c127dd23de151e09483cea87b0e64ab58514c"
        
        var path = "users/mackmobile/repos"
        var url = NSURL(string: "https://api.github.com/\(path)?client_id=\(clientID)&client_secret=\(clientSecret)")
        
        
        var jsonData = NSData(contentsOfURL: url!)
        var jsonRes: AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: nil)
        var resultado = jsonRes as! Array<NSDictionary>
        
        var repos = Array<String>()
        
        for item in resultado{
            let repo = item.objectForKey("full_name") as! String
            if verificarPulls(user, path: repo){
                println(repo)
                dm.insertEntity("Project", name:repo)
                let numPull = self.getPull(repo, usuario: user)
                
                if numPull != ""{
                    dm.createPullRequest(numPull, projectName: repo)
                    
                }
                self.getLabel(numPull, path: repo)
//                println(self.getLabel(numPull, path: repo))
                repos.append(repo)
            }
        }
    }
    
    func verificarPulls(usuario:String, path:String)->Bool{
        let clientID = "8fb09c4abdef8660c7a4"
        let clientSecret = "562c127dd23de151e09483cea87b0e64ab58514c"
        
        var url = NSURL(string: "https://api.github.com/repos/\(path)/pulls?client_id=\(clientID)&client_secret=\(clientSecret)")
        
        
        var jsonData = NSData(contentsOfURL: url!)
        var jsonRes: AnyObject! = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: nil)
        var resultado = jsonRes as! Array<NSDictionary>
        
        //        var tdsRepos = Array<String>()
        
        for item in resultado{
            let user = item.objectForKey("user") as! NSDictionary
            let num : String = (item.objectForKey("number") as! NSNumber).stringValue
            if user.objectForKey("login")! as! String  == usuario{
                //dm.createPullRequest(num, projectName: path);
                //("PullRequest", name: item.objectForKey("number"))
                return true
            }
        }
        
        return false
    }
    
    func getPull(path:String, usuario:String)->String{
        let clientID = "8fb09c4abdef8660c7a4"
        let clientSecret = "562c127dd23de151e09483cea87b0e64ab58514c"
        
        var url = NSURL(string: "https://api.github.com/repos/\(path)/pulls?client_id=\(clientID)&client_secret=\(clientSecret)")
        
        
        var jsonData = NSData(contentsOfURL: url!)
        var jsonRes: AnyObject! = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: nil)
        var resultado = jsonRes as! Array<NSDictionary>
        
        for item in resultado{
            let user = item.objectForKey("user") as! NSDictionary
            
            if user.objectForKey("login")! as! String  == usuario{
                let num : String = (item.objectForKey("number") as! NSNumber).stringValue
                return num
                //("PullRequest", name: item.objectForKey("number"))
            }
        }
        return ""
    }
    
    func getLabel(number:String, path:String){
        
        let clientID = "8fb09c4abdef8660c7a4"
        let clientSecret = "562c127dd23de151e09483cea87b0e64ab58514c"
        
        var url = NSURL(string: "https://api.github.com/repos/\(path)/issues/\(number)?client_id=\(clientID)&client_secret=\(clientSecret)")
        
        var jsonData = NSData(contentsOfURL: url!)
        var jsonRes: AnyObject! = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: nil)
        var resultado = jsonRes as! NSDictionary
        
        var labels: AnyObject? = resultado.objectForKey("labels")
        var lab = labels as! Array<NSDictionary>
        
        for item in lab{
            
            let color = item.objectForKey("color") as! String
            let name = item.objectForKey("name") as! String
            
            println("\(color),\(name)")
        }
//       return ""
    }
}
