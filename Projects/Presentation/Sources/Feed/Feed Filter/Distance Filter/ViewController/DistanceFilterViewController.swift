//
//  DistanceFilterViewController.swift
//  Presentation
//
//  Created by 유현진 on 8/1/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import ReactorKit

public protocol DistanceFilterViewControllerDelegate: AnyObject{
    func updatedDistanceState(distanceState: DistanceFilter)
}

public class DistanceFilterViewController: UIViewController {
    
    public var disposeBag: DisposeBag = DisposeBag()
    
    private lazy var distanceFilterView: DistanceFilterView = {
        return DistanceFilterView()
    }()
    
    public var distanceFilterDelegate: DistanceFilterViewControllerDelegate?
    
    private let customTransitioningDelegate: CustomTransitioningDelegate
    
    public init(distanceState: DistanceFilter){
        customTransitioningDelegate = CustomTransitioningDelegate(modalHeight: 230)
        super.init(nibName: nil, bundle: nil)
        self.reactor = DistanceFilterReactor(distanceState: distanceState)
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = customTransitioningDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI(){
        self.view.addSubview(distanceFilterView)
        distanceFilterView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    deinit{
        print("deinit DistanceFilterViewController")
    }
}
extension DistanceFilterViewController: View{
    public func bind(reactor: DistanceFilterReactor) {
        
        reactor.state.map{$0.distanceState}
            .map{$0.silderOffset}
            .take(1)
            .bind(to: distanceFilterView.distanceSlider.rx.value)
            .disposed(by: self.disposeBag)
        
        distanceFilterView.cancelButton.rx.tap
            .bind{ [weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: true)
            }.disposed(by: self.disposeBag)
        
        distanceFilterView.distanceSlider.rx.value
            .map{ value -> Float in
                return [0,1,2,3].min(by: { abs($0 - value) < abs($1 - value) }) ?? 0
            }.bind(to: distanceFilterView.distanceSlider.rx.value)
            .disposed(by: self.disposeBag)
        
        reactor.state.map{$0.valueChangedState}
            .distinctUntilChanged()
            .bind(to: distanceFilterView.resetButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        distanceFilterView.distanceSlider.rx.controlEvent([.touchUpInside, .touchUpOutside])
            .bind{ reactor.action.onNext(.changedValue)}
            .disposed(by: self.disposeBag)
        
        distanceFilterView.resetButton.rx.tap
            .bind{ [weak self] _ in
                guard let self = self else { return }
                distanceFilterView.distanceSlider.value = reactor.currentState.distanceState.silderOffset
                reactor.action.onNext(.reset)
            }.disposed(by: self.disposeBag)
    
        distanceFilterView.applyButton.rx.tap
            .bind{ [weak self] _ in
                guard let self = self else { return }
                reactor.action.onNext(.applyChangedValue(distanceFilterView.distanceSlider.value))
                self.distanceFilterDelegate?.updatedDistanceState(distanceState: reactor.currentState.distanceState)
                self.dismiss(animated: true)
            }.disposed(by: self.disposeBag)
    }
}
