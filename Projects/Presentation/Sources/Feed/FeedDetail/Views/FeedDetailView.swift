//
//  FeedDetailView.swift
//  Presentation
//
//  Created by 유현진 on 9/4/24.
//

import UIKit
import Common
import SnapKit

class FeedDetailView: UIView {
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    lazy var stickyImageView: StickyImageView = {
        return StickyImageView(frame: .zero)
    }()
    
    lazy var postView: PostView = {
        return PostView()
    }()
    
    private lazy var postRecordBreakLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.colorWithRGB(r: 232, g: 235, b: 237)
        return view
    }()
    
    lazy var recordView: FeedDetailRecordView = {
        return FeedDetailRecordView()
    }()
    
    lazy var runningResultMapView: RunningResultMapView = {
        return RunningResultMapView()
    }()
    
    private lazy var recordCommentBreakLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.colorWithRGB(r: 232, g: 235, b: 237)
        return view
    }()
    
    lazy var commentTableView: UITableView = {
        var tableView = UITableView(frame: .zero, style: .plain)
        tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        tableView.register(CommentHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: CommentHeaderFooterView.identifier)
        tableView.register(EmptyCommentFooterView.self, forHeaderFooterViewReuseIdentifier: EmptyCommentFooterView.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.sectionHeaderTopPadding = 0
        return tableView
    }()
    
    lazy var commentInputView: CommentInputView = {
        return CommentInputView()
    }()
    
    lazy var tapGesture: UITapGestureRecognizer = {
        return UITapGestureRecognizer()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.addSubview(scrollView)
        
        self.scrollView.addSubview(postView)
        self.scrollView.addSubview(postRecordBreakLine)
        self.scrollView.addSubview(recordView)
        self.scrollView.addSubview(runningResultMapView)
        self.scrollView.addSubview(recordCommentBreakLine)
        self.scrollView.addSubview(commentTableView)
        self.addSubview(commentInputView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(commentInputView.snp.top)
        }
        
        postView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        postRecordBreakLine.snp.makeConstraints { make in
            make.top.equalTo(postView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(8)
        }
        
        recordView.snp.makeConstraints { make in
            make.top.equalTo(postRecordBreakLine.snp.bottom)
            make.left.right.width.equalToSuperview()
        }
        
        runningResultMapView.snp.makeConstraints { make in
            make.top.equalTo(recordView.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        recordCommentBreakLine.snp.makeConstraints { make in
            make.top.equalTo(runningResultMapView.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(8)
        }
        
        commentTableView.snp.makeConstraints { make in
            make.top.equalTo(recordCommentBreakLine.snp.bottom)
            make.left.right.width.equalToSuperview()
            make.height.equalTo(commentTableView.contentSize.height)
            make.bottom.equalToSuperview()
        }
        
        commentInputView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
    }
    
    private func configureTapGesture(){
        self.runningResultMapView.mapView.addGestureRecognizer(tapGesture)
    }
}
