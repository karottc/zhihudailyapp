//
//  ViewController.swift
//  zhihuDaily
//
//  Created by k on 15/7/18.
//  Copyright © 2015年 com.karottc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    let tv = UITableView()
    var arr = Array<Dictionary<String, String> >()  // 上拉加载更多
    let zhihu = ZhihuData()
    
    var page = 1   // 下拉加载后的页数
    
    let tableFooterView = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.whiteColor()
        //let topView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 60))
        //topView.backgroundColor = UIColor.orangeColor()
        //self.view.addSubview(topView)
        
        initArr()
        
        tv.delegate = self
        print("hight: \(self.view.frame.height)")
        tv.frame = CGRectMake(0, 50, self.view.frame.width, self.view.frame.height-60)
        tv.dataSource = self
        
        tv.registerClass(UITableViewCell.self, forCellReuseIdentifier: "zhihuIndex")
        self.createTableFooter()
        self.view.addSubview(tv)
    }
    
    func initArr() {
        
        zhihu.getHomeList()
        sleep(1)
        
        for dic in zhihu.idlist {
            arr.append(dic)
        }
    }
    func arrMore() {
        let num = arr.count
        if num <= 0 {
            initArr()
            return
        }
        zhihu.getNextList(arr[num - 1]["timestamp"]!)
        sleep(1)
        
        for dic in zhihu.idlist {
            arr.append(dic)
        }
    }
    func createTableFooter() {
        //self.tv.tableFooterView = nil
        tableFooterView.frame = CGRectMake(0, 0, self.tv.bounds.size.width, 60)
        tableFooterView.text = "上拉加载更多"
        tableFooterView.textAlignment = NSTextAlignment.Center
        self.tv.tableFooterView = tableFooterView
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("zhihuIndex", forIndexPath: indexPath) as! UITableViewCell
        let title = arr[indexPath.row]["title"]!
        let date = arr[indexPath.row]["date"]!
        let imgUrl = arr[indexPath.row]["img"]!
        cell.textLabel!.text = "  \(date)\t\(title)"
        let url:NSURL = NSURL(string: imgUrl)!
        let imgData:NSData = NSData(contentsOfURL: url)!
        let img = UIImage(data: imgData)
        cell.imageView!.image = img
        cell.textLabel!.numberOfLines = 0
        
        //cell.textLabel!.
        //print("cell hight: \(cell.frame.height)")
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height+30) {
            tableFooterView.text = "松开载入更多"
        } else {
            tableFooterView.text = "上拉查看更多"
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        tableFooterView.text = "上拉查看更多"
        
        if scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height+30) {
            self.arrMore()
            self.tv.reloadData()
        }
    }
    
    // UITableViewDelegate方法，处理列表项的选中事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tv.deselectRowAtIndexPath(indexPath, animated: true)
        
        //let itemString = self.arr[indexPath.row]
        let id = self.arr[indexPath.row]["id"]
        /*
        let alertview = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alertview.title = "提示！"
        alertview.message = "你选中了【\(itemString)】"
        let action = UIAlertAction(title: "确定", style: .Default, handler: secondView)
        alertview.addAction(action)
        self.presentViewController(alertview, animated: true, completion: nil)
        self.view.bringSubviewToFront(detailView)
        */
        self.presentViewController(StoryDetailView(id: id!), animated: true, completion: nil)
    }
    
    func secondView(alertAction:UIAlertAction) -> Void {
        //self.presentViewController(StoryDetailView(id: "123333", mainView: self), animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

