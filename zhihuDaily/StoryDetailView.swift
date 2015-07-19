//
//  StoryDetailView.swift
//  zhihuDaily
//
//  Created by k on 15/7/19.
//  Copyright © 2015年 com.karottc. All rights reserved.
//

import Foundation
import UIKit

class StoryDetailView:UIViewController, UITableViewDataSource {
    let tv = UITableView()
    let zhihu = ZhihuData()
    var storyList = Array<Dictionary<String, String> >()
    var answerList = Array<Dictionary<String, String> >()
    
    var answerAll = 0
    
    init(id:String) {
        super.init(nibName:nil, bundle:nil)
        print("id: \(id)")
        zhihu.getStoryDetail(id)
        sleep(1)
        
        for dict in zhihu.storyList {
            self.storyList.append(dict)
        }
        for dict in zhihu.answerList {
            self.answerList.append(dict)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        print("hight: \(self.view.frame.height)")
        tv.frame = CGRectMake(0, 50, self.view.frame.width, self.view.frame.height-60)
        tv.dataSource = self
        
        tv.registerClass(UITableViewCell.self, forCellReuseIdentifier: "detail")
        self.view.addSubview(tv)
        
        setupSwipeGuestures()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storyList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("detail", forIndexPath: indexPath) as! UITableViewCell
        let cell = UITableViewCell(frame: CGRectMake(0, 0, self.view.bounds.size.width, 120))
        let quest_title = storyList[indexPath.row]["title"]!
        let num = Int(storyList[indexPath.row]["answer_num"]!)
        var author:String = ""
        author += answerList[answerAll+num!-1]["author"]!
        author += ", "
        author += answerList[answerAll+num!-1]["bio"]!
        
        let answer = answerList[answerAll+num!-1]["answer"]!
        
        cell.textLabel!.text = "\(quest_title)\n\(author)\n\(answer)"
        cell.textLabel!.numberOfLines = 0
        answerAll += num!
        return cell
    }
    
    func setupSwipeGuestures() {
        // 监听向右滑动，返回前一个页面
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("swipeRight"))
        rightSwipe.numberOfTouchesRequired = 1
        rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(rightSwipe)
    }
    func swipeRight() {
        // 返回前一个页面
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}