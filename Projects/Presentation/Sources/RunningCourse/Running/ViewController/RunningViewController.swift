//
//  RunningViewController.swift
//  Presentation
//
//  Created by najin on 7/7/24.
//

import UIKit
import RxSwift
import ReactorKit
import RxRelay

final public class RunningViewController: UIViewController {
    
    //MARK: - Properties
    
    public var coordinator: RunningCoordinatorInterface?
    
    public var disposeBag = DisposeBag()
    
    private lazy var runningView: RunningView = {
        return RunningView()
    }()
    
    //MARK: - Lifecycle
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(reactor: RunningReactor){
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    deinit {
        print("deinit RunningCourseViewController")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    //MARK: - Configure
    
    private func configureUI() {
        self.view.backgroundColor = .BaseWhite
        self.view.addSubview(runningView)
        
        runningView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension RunningViewController: View{
    
    public func bind(reactor: RunningReactor) {
        
        //MARK: Timer 시작 전 Ready 화면 binding
        
        Observable.just(Reactor.Action.readyForRunning)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map{$0.readyTime}
            .distinctUntilChanged()
            .bind{ [weak self] time in
                guard let self = self else { return }
                
                if time == 0 {
                    self.runningView.runningRecordView.initRunningData()
                    reactor.action.onNext(.startRunning)
                }
                self.runningView.setReadyView(time: time)
            }.disposed(by: self.disposeBag)
        
        //MARK: 초마다 Record 값 갱신
        
        reactor.state
            .map{$0.isRunning}
            .distinctUntilChanged()
            .skip(1)
            .bind{ [weak self] isRunning in
                guard let self = self else { return }
                self.runningView.runningRecordView.toggleRunningState(isRunning: isRunning)
            }.disposed(by: self.disposeBag)
        
        reactor.state
            .map{$0.runningTime}
            .distinctUntilChanged()
            .skip(1)
            .bind{ [weak self] time in
                guard let self = self else { return }
                self.runningView.runningRecordView.setRunningData(time: time, averagePace: nil, calorie: nil)
            }.disposed(by: self.disposeBag)
        
        //MARK: play, pause, stop buttons - tap event
        
        runningView.runningRecordView.pauseButton.rx.tap
            .bind{ [weak self] _ in
                guard let _ = self else { return }
                reactor.action.onNext(.pauseRunning)
            }.disposed(by: self.disposeBag)
        
        runningView.runningRecordView.playButton.rx.tap
            .bind{ [weak self] _ in
                guard let _ = self else { return }
                reactor.action.onNext(.startRunning)
            }.disposed(by: self.disposeBag)
        
        runningView.runningRecordView.stopButton.rx.tap
            .bind { [weak self] _ in
                guard let _ = self else { return }
                //TODO: 토스트 메시지 출력 (오늘의 운동을 중지하시려면 길게 눌러주세요)
            }
            .disposed(by: disposeBag)
        
        runningView.runningRecordView.stopButtonlongPressGesture.rx.event
            .filter { $0.state == .began }
            .bind { [weak self] _ in
                guard let self = self else { return }
                reactor.action.onNext(.stopRunning)
                self.coordinator?.showRunningResult()
            }
            .disposed(by: disposeBag)
    }
}
