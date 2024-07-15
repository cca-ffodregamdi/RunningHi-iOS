//
//  NoticeViewController.swift
//  Presentation
//
//  Created by 유현진 on 7/15/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import ReactorKit

public class NoticeViewController: UIViewController {

    public var disposeBag: DisposeBag = DisposeBag()
    
    public var coordinator: MyCoordinatorInterface?
    
    public override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    public init(reactor: NoticeReactor){
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NoticeViewController: View{

    public func bind(reactor: NoticeReactor) {
        
    }
}

