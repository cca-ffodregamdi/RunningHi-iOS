//
//  SortFilterViewController.swift
//  Presentation
//
//  Created by 유현진 on 8/2/24.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import SnapKit

public protocol SortfilterViewControllerDelegate: AnyObject{
    func updatedSortState(sortState: SortFilter)
}

public class SortFilterViewController: UIViewController {

    public var disposeBag: DisposeBag = DisposeBag()
    
    private lazy var sortFilterView: SortFilterView = {
        return SortFilterView()
    }()
    
    public var sortFilterDelegate: SortfilterViewControllerDelegate?
    
    private let customTransitioningDelegate: CustomTransitioningDelegate
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    public init(sortState: SortFilter){
        customTransitioningDelegate = CustomTransitioningDelegate(modalHeight: 260)
        super.init(nibName: nil, bundle: nil)
        self.reactor = SortFilterReactor(sortFilter: sortState)
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = customTransitioningDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        print("deinit SortFilterViewController")
    }
    
    private func configureUI(){
        self.view.addSubview(sortFilterView)
        
        sortFilterView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
extension SortFilterViewController: View{
    public func bind(reactor: SortFilterReactor) {
        
        sortFilterView.cancelButton.rx.tap
            .bind{ [weak self] _ in
                guard let self = self else { return }
                if reactor.currentState.updatedState{
                    self.sortFilterDelegate?.updatedSortState(sortState: reactor.currentState.sortState)
                }
                self.dismiss(animated: true)
            }.disposed(by: self.disposeBag)
        
        reactor.state.map{$0.sortList}
            .bind(to: sortFilterView.sortFilterTableView.rx.items){ tableView, index, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: SortFilterTableViewCell.identitier) as! SortFilterTableViewCell
                cell.configureModel(title: item.title)
                return cell
            }.disposed(by: self.disposeBag)
        
        reactor.state.map{$0.sortState}
            .compactMap{ reactor.currentState.sortList.firstIndex(of: $0) }
            
            .bind{ [weak self] index in
                guard let self = self else { return }
                self.sortFilterView.sortFilterTableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .none)
            }.disposed(by: self.disposeBag)
        
        sortFilterView.sortFilterTableView.rx.itemSelected
            .map{Reactor.Action.seletedSortIndex($0.row)}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }
}

