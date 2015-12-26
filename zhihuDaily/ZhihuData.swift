//
//  ZhihuData.swift
//  zhihuDaily
//
//  Created by k on 15/7/18.
//  Copyright © 2015年 com.karottc. All rights reserved.
//

import Foundation

class ZhihuData: NSObject, NSURLConnectionDelegate {
    var idlist = Array<Dictionary<String, String> >()
    var storyList = Array<Dictionary<String, String> >()
    var answerList = Array<Dictionary<String, String> >()
    
    func getHomeList() {
        print("==================home list=================")
        let urlString:String = "http://104.128.85.9:8001/api/gethomelist"
        let url:NSURL = NSURL(string: urlString)!
        
        let urlSession:NSURLSession = NSURLSession.sharedSession()
        let task = urlSession.dataTaskWithURL(url, completionHandler: getURLData)
        task.resume()
    }
    func getNextList(timestamp:String) {
        print("==================next list=================timestamp=\(timestamp)")
        let urlString:String = "http://104.128.85.9:8001/api/getnextlist?timestamp=" + timestamp
        let url:NSURL = NSURL(string: urlString)!
        let urlSession:NSURLSession = NSURLSession.sharedSession()
        let task = urlSession.dataTaskWithURL(url, completionHandler: getURLData)
        task.resume()
    }
    func getURLData(data:NSData?, response:NSURLResponse?, error:NSError?) -> Void {
        print("-------------url session---------")
        if error != nil {
            print("error")
            return
        }
        
        var json:AnyObject
        
        do {
            json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
        } catch {
            print("exception.")
            return
        }
        let number = json["number"] as! Int
        idlist.removeAll()
        for i in 0..<number {
            let id = json.objectForKey("stories")?.objectAtIndex(i).objectForKey("id") as! Int
            let title = json.objectForKey("stories")?.objectAtIndex(i).objectForKey("title") as! String
            let strDate = json.objectForKey("stories")?.objectAtIndex(i).objectForKey("display_date") as! String
            let img = json.objectForKey("stories")?.objectAtIndex(i).objectForKey("images") as! String
            let timestamp = json.objectForKey("stories")?.objectAtIndex(i).objectForKey("timestamp") as! Int
            
            //print("id=\(id)")
            //print("title=\(title), date=\(strDate), timestamp=\(timestamp)")
            //print("img=\(img)")
            //print("********************************")
            
            var idDict = Dictionary<String, String>()
            idDict["id"] = "\(id)"
            idDict["date"] = strDate
            idDict["title"] = title
            idDict["timestamp"] = "\(timestamp)"
            idDict["img"] = img
            
            //print("\(idDict["date"])")
            
            idlist.append(idDict)
        }
        print("idList sieze: \(idlist.count)")
    }
    
    func getStoryDetail(id:String) {
        print("==================next list=================id=\(id)")
        let urlString:String = "http://104.128.85.9:8001/api/getstorydetail?id=" + id
        let url:NSURL = NSURL(string: urlString)!
        let urlSession:NSURLSession = NSURLSession.sharedSession()
        let task = urlSession.dataTaskWithURL(url, completionHandler: getStoryData)
        task.resume()
    }
    
    func getStoryData(data:NSData?, response:NSURLResponse?, error:NSError?) -> Void {
        print("-------------url detail session---------")
        if error != nil {
            print("error")
            return
        }
        
        var json:AnyObject
        do {
            json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
        } catch {
            print("story detail exception.")
            return
        }
        
        let quest_num:Int = json.objectForKey("question_num") as! Int
        storyList.removeAll()
        answerList.removeAll()
        for i in 0..<quest_num {
            var storyDict = Dictionary<String, String>()
            let question_title:String = json.objectForKey("stories")?.objectAtIndex(i).objectForKey("question_title") as! String
            print("question: \(question_title)")
            let answer_num:Int = json.objectForKey("stories")?.objectAtIndex(i).objectForKey("answer_num") as! Int
            for j in 0..<answer_num {
                var answerDict = Dictionary<String, String>()
                let author:String = json.objectForKey("stories")?.objectAtIndex(i).objectForKey("answers")?.objectAtIndex(j).objectForKey("author") as! String
                let bio:String = json.objectForKey("stories")?.objectAtIndex(i).objectForKey("answers")?.objectAtIndex(j).objectForKey("bio") as! String
                let answer:String = json.objectForKey("stories")?.objectAtIndex(i).objectForKey("answers")?.objectAtIndex(j).objectForKey("answer") as! String
                let avatar:String = json.objectForKey("stories")?.objectAtIndex(i).objectForKey("answers")?.objectAtIndex(j).objectForKey("avatar") as! String
                
                
                print("author: \(author), \(bio)")
                print("answer: \(answer)")
                print("--------------------------")
                
                answerDict["author"] = author
                answerDict["bio"] = bio
                answerDict["avatar"] = avatar
                answerDict["answer"] = answer
                
                answerList.append(answerDict)
            }
            let viewmore:String = json.objectForKey("stories")?.objectAtIndex(i).objectForKey("viewmore") as! String
            print("viewmore: \(viewmore)")
            print("************************************************************************")
            
            storyDict["title"] = question_title
            storyDict["answer_num"] = "\(answer_num)"
            storyDict["viewmore"] = viewmore
            
            storyList.append(storyDict)
        }
    }
}