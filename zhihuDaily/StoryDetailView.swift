//
//  StoryDetailView.swift
//  zhihuDaily
//
//  Created by k on 15/7/19.
//  Copyright © 2015年 com.karottc. All rights reserved.
//

import Foundation
import UIKit

class StoryDetailView:UIViewController, UITableViewDataSource,UITableViewDelegate {
    let tv = UITableView(frame: CGRectMake(0, 0, 0, 0), style: UITableViewStyle.Grouped)
    let zhihu = ZhihuData()
    var storyList = Array<Dictionary<String, String> >()
    var answerList = Array<Dictionary<String, String> >()
    
    var answerAll = 0
    var groupNum = 2
    
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
        
        //tv.style = UITableViewStyle.Grouped
        tv.delegate = self
        self.view.backgroundColor = UIColor.whiteColor()
        print("hight: \(self.view.frame.height)")
        tv.frame = CGRectMake(0, 50, self.view.frame.width, self.view.frame.height-60)
        tv.dataSource = self
        //tv.s
        
        tv.registerClass(UITableViewCell.self, forCellReuseIdentifier: "detail")
        self.view.addSubview(tv)
        
        setupSwipeGuestures()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return storyList.count / groupNum
        return 1
        //return storyList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("detail", forIndexPath: indexPath) as! UITableViewCell
        let numIndex = indexPath.section + indexPath.row
        //let numIndex = indexPath.row

        let quest_title = storyList[numIndex]["title"]!
        let num = Int(storyList[numIndex]["answer_num"]!)
        let dataDict = storyList[numIndex]
        
        //let cell = TableViewCell(cellid: "detail",startNum: answerAll, data: dataDict, ansDict: answerList)

        //print("storylist=\(storyList.count)")
        if storyList.count <= answerAll+num!-1 {
            return cell
        }
        var author:String = ""
        print("number index=\(answerAll+num!-1), indexpath=\(numIndex), storlist=\(storyList.count)")
        author += answerList[answerAll+num!-1]["author"]!
        author += ", "
        author += answerList[answerAll+num!-1]["bio"]!
        
        let answer = answerList[answerAll+num!-1]["answer"]!
        
        cell.textLabel!.text = "\(quest_title)\n\n\(author)\n\n\(answer)\n"
        cell.textLabel!.numberOfLines = 0
        answerAll += num!
        
        print(cell.frame.height)
        
        return cell
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //return groupNum
        let num = storyList.count
        print("section number=\(num)")
        self.groupNum = num
        return num
        //return 1
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //print("change heiht:")
        return 200
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