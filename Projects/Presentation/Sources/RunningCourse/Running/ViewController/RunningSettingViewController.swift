//
//  RunningSettingViewController.swift
//  Presentation
//
//  Created by najin on 7/7/24.
//

import UIKit
import RxSwift
import ReactorKit
import RxRelay
import Domain

final public class RunningSettingViewController: UIViewController {
    
    //MARK: - Properties
    
    public var coordinator: RunningCoordinatorInterface?
    
    private let distanceDatas = Array(1...20)
    private let hourDatas = Array(0...23)
    private let minuteDatas = Array(0...59)
    
    public var disposeBag = DisposeBag()
    
    private lazy var runningSettingView: RunningSettingView = {
        return RunningSettingView()
    }()
    
    //MARK: - Lifecycle
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = RunningSettingReactor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit RunningSettingViewController")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureUI()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: - Configure
    
    private func configureNavigationBar() {
        self.title = "목표러닝"
        self.navigationController?.navigationBar.tintColor = .black
        
        let backButton: UIButton = UIButton(type: .custom)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.addTarget(self, action: #selector(customBackAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func configureUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(runningSettingView)
        
        runningSettingView.snp.makeConstraints { make in
            make.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        self.runningSettingView.distancePickerView.rx.setDelegate(self).disposed(by: disposeBag)
        self.runningSettingView.timePickerView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    //MARK: - Helpers
    
    @objc func customBackAction() {
        coordinator?.finishRunning()
    }
}

// MARK: - Binding

extension RunningSettingViewController: View {
    
    public func bind(reactor: RunningSettingReactor) {
        bindingView(reactor: reactor)
        bindingButtonAction(reactor: reactor)
    }
    
    private func bindingView(reactor: RunningSettingReactor) {
        
        self.runningSettingView.distancePickerView.rx.itemSelected
            .subscribe(onNext: { [weak self] row, component in
                guard let self = self else { return }
                reactor.action.onNext(.selectDistance(self.distanceDatas[row]))
            })
            .disposed(by: disposeBag)
        
        self.runningSettingView.timePickerView.rx.itemSelected
            .subscribe(onNext: { [weak self] row, component in
                guard let self = self else { return }
                if component == 0 {
                    reactor.action.onNext(.selectHour(self.hourDatas[row]))
                } else {
                    reactor.action.onNext(.selectMinute(self.minuteDatas[row]))
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map{$0.settingType}
            .distinctUntilChanged()
            .bind{ [weak self] type in
                guard let self = self else { return }
                self.runningSettingView.setSettingType(type)
            }.disposed(by: self.disposeBag)
    }
    
    private func bindingButtonAction(reactor: RunningSettingReactor) {
        runningSettingView.distanceButton.rx.tap
            .bind{ [weak self] _ in
                guard let _ = self else { return }
                reactor.action.onNext(.tapSettingTypeButton(.distance))
            }.disposed(by: self.disposeBag)
        
        runningSettingView.timeButton.rx.tap
            .bind{ [weak self] _ in
                guard let _ = self else { return }
                reactor.action.onNext(.tapSettingTypeButton(.time))
            }.disposed(by: self.disposeBag)
        
        runningSettingView.playButton.rx.tap
            .bind{ [weak self] _ in
                guard let self = self else { return }
                switch reactor.currentState.settingType {
                case .distance:
                    self.coordinator?.startRunning(settingType: .distance, value: reactor.currentState.selectedDistance)
                case .time:
                    let time = (reactor.currentState.selectedHours * 60 * 60) + (reactor.currentState.selectedMinutes * 60)
                    self.coordinator?.startRunning(settingType: .time, value: time)
                }
            }.disposed(by: self.disposeBag)
    }
}

//MARK: - Extension PickerView

extension RunningSettingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == self.runningSettingView.distancePickerView {
            return 1
        } else {
            return 2
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.runningSettingView.distancePickerView {
            return distanceDatas.count
        } else {
            if component == 0 {
                return hourDatas.count
            } else {
                return minuteDatas.count
            }
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if #available(iOS 14.0, *) {
            for subview in pickerView.subviews {
                subview.backgroundColor = .clear
            }
        }

        let label = UILabel()
        label.textAlignment = .center
        
        if pickerView == self.runningSettingView.distancePickerView {
            label.font = .systemFont(ofSize: 90, weight: .bold)
            label.text = "\(distanceDatas[row])"
        } else {
            label.font = .systemFont(ofSize: 70, weight: .bold)
            
            if component == 0 {
                label.text = "\(hourDatas[row])"
            } else {
                label.text = "\(minuteDatas[row])"
            }
        }
        return label
    }
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        if pickerView == self.runningSettingView.distancePickerView {
            return 110
        } else {
            return 80
        }
    }
}
