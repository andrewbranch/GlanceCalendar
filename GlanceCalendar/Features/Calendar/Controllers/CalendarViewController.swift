import Cocoa
import SwiftMoment
import Carbon

protocol CalendarViewDelegate {
    func calendarViewController(viewController: CalendarViewController, didRequestSelectedTime time: Moment) -> Void
    func calendarViewController(viewController: CalendarViewController, didRequestMonthChange addMonths: Int) -> Void
    func calendarViewControllerDidRequestSelectedTimeToNow(viewController: CalendarViewController) -> Void
}

class CalendarViewController: NSViewController {
    let dayViewSize: CGFloat = 24
    let dayViewMargin: CGFloat = 4
    let controlButtonMargin: CGFloat = 0
    let calendar = CalendarGrid()
    
    var delegate: CalendarViewDelegate
    var calendarHeightConstraint: NSLayoutConstraint?
    var dayViewControllers: [CalendarDayViewController] = []
    @IBOutlet var insetView: NSView!
    @IBOutlet var headerView: CalendarHeaderView!
    @IBOutlet var monthLabel: NSTextField!

    init(delegate: CalendarViewDelegate) {
        self.delegate = delegate
        super.init(nibName: "CalendarViewController", bundle: nil)
        CarbonKeyHandler.shared.addHandler(forSpecialKey: .leftArrow) { [weak self] in self?.goToPreviousMonth() }
        CarbonKeyHandler.shared.addHandler(forSpecialKey: .rightArrow) { [weak self] in self?.goToNextMonth() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarHeightConstraint = insetView.heightAnchor.constraint(equalToConstant: 0) // Set and activated in updateCalendar()
        insetView.widthAnchor.constraint(equalToConstant: 7 * (dayViewSize + dayViewMargin) - dayViewMargin).isActive = true
        let widthConstraint = view.widthAnchor.constraint(equalTo: insetView.widthAnchor, constant: dayViewMargin * 2)
        widthConstraint.priority = .defaultHigh
        widthConstraint.isActive = true
        
        
        let monthControlsContainer = NSView()
        let prevButton = MonthControlButton(imageName: "arrowLeft", target: self, action: #selector(self.goToPreviousMonth))
        let todayButton = MonthControlButton(imageName: "dot", target: self, action: #selector(self.goToToday))
        let nextButton = MonthControlButton(imageName: "arrowRight", target: self, action: #selector(self.goToNextMonth))
        monthControlsContainer.translatesAutoresizingMaskIntoConstraints = false
        monthControlsContainer.subviews = [prevButton, todayButton, nextButton]
        headerView.addSubview(monthControlsContainer)
        nextButton.trailingAnchor.constraint(equalTo: monthControlsContainer.trailingAnchor).isActive = true
        todayButton.trailingAnchor.constraint(equalTo: nextButton.leadingAnchor, constant: -controlButtonMargin).isActive = true
        prevButton.trailingAnchor.constraint(equalTo: todayButton.leadingAnchor, constant: -controlButtonMargin).isActive = true
        monthControlsContainer.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerYAnchor.constraint(equalTo: monthControlsContainer.centerYAnchor).isActive = true
        }
        monthControlsContainer.heightAnchor.constraint(equalTo: headerView.heightAnchor).isActive = true
        monthControlsContainer.widthAnchor.constraint(equalToConstant: prevButton.frame.width + nextButton.frame.width + todayButton.frame.width + 2 * controlButtonMargin).isActive = true
        monthControlsContainer.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        monthControlsContainer.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
        
        let now = Clock.shared.currentTick
        updateCalendar(currentTime: now, selectedTime: now)
    }
    
    @objc func goToToday() {
        delegate.calendarViewControllerDidRequestSelectedTimeToNow(viewController: self)
    }
    
    @objc func goToPreviousMonth() {
        delegate.calendarViewController(viewController: self, didRequestMonthChange: -1)
    }
    
    @objc func goToNextMonth() {
        delegate.calendarViewController(viewController: self, didRequestMonthChange: 1)
    }
    
    func updateCalendar(currentTime: Moment, selectedTime: Moment) {
        dayViewControllers.forEach {
            $0.view.viewWillMove(toSuperview: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }

        let weeks = calendar.getWeeks(month: selectedTime.month, year: selectedTime.year)
        dayViewControllers = []
        monthLabel.stringValue = weeks[1][0].monthName
        if weeks[1][0].year != currentTime.year {
            monthLabel.stringValue += " \(weeks[1][0].year)"
        }
        weeks.enumerated().forEach { week in
            week.element.enumerated().forEach { day in
                let vc = CalendarDayViewController(
                    frame: NSRect(
                        x: CGFloat(day.offset) * (dayViewSize + dayViewMargin),
                        y: CGFloat(weeks.count - 1 - week.offset) * (dayViewSize + dayViewMargin),
                        width: dayViewSize,
                        height: dayViewSize
                    ),
                    day: day.element.day,
                    isToday: day.element.isSameDay(currentTime),
                    inAdjacentMonth: !day.element.isSameMonth(selectedTime),
                    onClick: { [weak self] in
                        self?.delegate.calendarViewController(viewController: self!, didRequestSelectedTime: day.element)
                    }
                )
                vc.isSelected = day.element.isSameDay(selectedTime)
                addChild(vc)
                insetView.addSubview(vc.view)
                dayViewControllers.append(vc)
            }
        }

        let calendarHeight = CGFloat(weeks.count) * (dayViewSize + dayViewMargin) - dayViewMargin
        calendarHeightConstraint!.constant = calendarHeight
        calendarHeightConstraint!.isActive = true
        // Without this (even with `view.needsLayout = true`), the view flashes in
        // at the wrong size before adjusting when the menu first opens.
        view.layoutSubtreeIfNeeded()
    }
    
    func getDayViewController(forDay day: Int) -> CalendarDayViewController? {
        return dayViewControllers.first { !$0.inAdjacentMonth && $0.day == day }
    }
    
    func updateSelectedDay(prevDay: Moment, nextDay: Moment) {
        getDayViewController(forDay: prevDay.day)?.isSelected = false
        getDayViewController(forDay: nextDay.day)?.isSelected = true
    }
    
    func updateCurrentDay(prevDay: Moment, nextDay: Moment) {
        getDayViewController(forDay: prevDay.day)?.isToday = false
        getDayViewController(forDay: nextDay.day)?.isToday = true
    }
}
