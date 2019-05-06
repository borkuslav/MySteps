//
//  StepsChartView.swift
//  MySteps
//
//  Created by Bogusław Parol on 03/03/2019.
//  Copyright © 2019 Boguslaw Parol. All rights reserved.
//

import Foundation
import UIKit
import CorePlot

class StepsChartView: UIView {
    
    private var chartDataSource: StepsChartViewDataSource?
    
    init(frame: CGRect, stepsReports: [DailyStepsReport]) {
        super.init(frame: frame)
    
        self.createGraph(hostingView: self.createAndAddHostingView(), stepsReports: stepsReports)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createAndAddHostingView() -> CPTGraphHostingView {
        let hostingView = CPTGraphHostingView(frame: self.bounds)
        hostingView.clipsToBounds = false
        self.addSubview(hostingView)
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingView.leftAnchor.constraint(equalTo: self.leftAnchor),
            hostingView.topAnchor.constraint(equalTo: self.topAnchor),
            hostingView.rightAnchor.constraint(equalTo: self.rightAnchor),
            hostingView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        return hostingView
    }
    
    private func createGraph(hostingView: CPTGraphHostingView, stepsReports: [DailyStepsReport]) {
        
        let maxStepsDaily = stepsReports.map({ $0.steps }).max()
        
        // create graph
        let graph = CPTXYGraph(frame: self.bounds)
        graph.paddingLeft = 0
        graph.paddingRight = 0
        graph.paddingTop = 0
        graph.paddingBottom = 0
        graph.plotAreaFrame?.paddingBottom = 50
        let theme = CPTTheme.init(named: CPTThemeName.plainBlackTheme)
        theme?.apply(toBackground: graph)
        
        // create plot dataSource
        let dataSourceLinePlot = CPTScatterPlot()
        dataSourceLinePlot.identifier = "Data source plot" as NSString
        // TODO: this interpolation with such few records is very poor
        dataSourceLinePlot.interpolation = CPTScatterPlotInterpolation.curved
        
        // configure grid line styles
        let majorGridLineStyle = CPTMutableLineStyle.init()
        majorGridLineStyle.lineWidth = 0.75
        majorGridLineStyle.lineColor = CPTColor(genericGray: 0.5)
        
        // configure axes
        if let axisSet = graph.axisSet as? CPTXYAxisSet, let xAxis = axisSet.xAxis, let yAxis = axisSet.yAxis {
            
            let xAxisLineStyle = xAxis.axisLineStyle?.mutableCopy() as? CPTMutableLineStyle
            xAxisLineStyle?.lineWidth = 0
            xAxis.axisLineStyle = xAxisLineStyle
            let xAxisMinorTickStyle = xAxis.minorTickLineStyle?.mutableCopy() as?  CPTMutableLineStyle
            xAxisMinorTickStyle?.lineWidth = 0
            xAxis.minorTickLineStyle = xAxisMinorTickStyle
            let xAxisMajorTickStyle = xAxis.majorTickLineStyle?.mutableCopy() as?  CPTMutableLineStyle
            xAxisMajorTickStyle?.lineWidth = 0
            xAxis.majorTickLineStyle = xAxisMajorTickStyle
            xAxis.majorIntervalLength = 5
            xAxis.orthogonalPosition = 1.0
            xAxis.minorTicksPerInterval = 4
            xAxis.labelTextStyle = CPTTextStyle(attributes: [
                NSAttributedString.Key.foregroundColor.rawValue: UIColor.white.withAlphaComponent(0.5)
            ])
            xAxis.labelFormatter = AxisXLabelFormatter(stepsReports: stepsReports)
            //xAxis.minorTickLabelFormatter = AxisXLabelFormatter(stepsReports: stepsReports)
            xAxis.minorTickLabelTextStyle = CPTTextStyle(attributes: [
                NSAttributedString.Key.foregroundColor.rawValue: UIColor.white.withAlphaComponent(0.5)
            ])
            xAxis.labelAlignment = .top
            //xAxis.majorGridLineStyle = majorGridLineStyle
            
            let yAxisLineStyle = yAxis.axisLineStyle?.mutableCopy() as? CPTMutableLineStyle
            yAxisLineStyle?.lineWidth = 0
            yAxis.axisLineStyle = yAxisLineStyle
            let yAxisMinorTickLineStyle = yAxis.minorTickLineStyle?.mutableCopy() as? CPTMutableLineStyle
            yAxisMinorTickLineStyle?.lineWidth = 0
            yAxis.minorTickLineStyle = yAxisMinorTickLineStyle
            let yAxisMajorTickLineStyle = yAxis.majorTickLineStyle?.mutableCopy() as? CPTMutableLineStyle
            yAxisMajorTickLineStyle?.lineWidth = 0
            yAxis.majorTickLineStyle = yAxisMajorTickLineStyle
            
            if let maxSteps = maxStepsDaily {                
                let majorIntervalLength = Double(maxSteps) / 3.0
                let rounded = getRoundedToNearest(majorIntervalLength: Float(majorIntervalLength))
                yAxis.majorIntervalLength = NSNumber(value: rounded)
            }
            yAxis.orthogonalPosition = 1.0
            yAxis.minorTicksPerInterval = 5
            yAxis.majorGridLineStyle = majorGridLineStyle
            yAxis.labelTextStyle = CPTTextStyle(attributes: [
                NSAttributedString.Key.foregroundColor.rawValue: UIColor.white.withAlphaComponent(0.5)
            ])
            yAxis.labelFormatter = AxisYLabelFormatter()
            yAxis.labelAlignment = .bottom
            yAxis.tickDirection = .negative
            // TODO: labels position depends on number of records - duno how yet...workaround:            
            yAxis.labelOffset = -self.bounds.size.width + CGFloat(60 - stepsReports.count)
            
            graph.axisSet?.axes = [xAxis, yAxis]
        }
        
        // confugure plot space
        if let plotSpace = graph.defaultPlotSpace as? CPTXYPlotSpace {
            plotSpace.scale(toFit: [dataSourceLinePlot])
            plotSpace.xRange = CPTPlotRange(location: -1.0, length: NSNumber(value: stepsReports.count + 2))
            if let yRange = maxStepsDaily {
                plotSpace.yRange = CPTPlotRange(location: NSNumber(value: 0.0), length: NSNumber(value: Double(yRange) * 1.3))
            } else {
                plotSpace.yRange = CPTPlotRange(location: 0.0, length: NSNumber(value: 10000))
            }
        }
        
        // configure line style
        if let lineStyle = dataSourceLinePlot.dataLineStyle?.mutableCopy() as? CPTMutableLineStyle {
            lineStyle.lineWidth = 3.0
            let gradientBeginingColor = CPTColor(componentRed: 0, green: 116.0/255.0, blue: 1, alpha: 1)
            let gradientEndColor = CPTColor(componentRed: 180.0/255.0, green: 236.0/255.0, blue: 81.0/255.0, alpha: 1)
            lineStyle.lineColor = gradientBeginingColor
            let lineGradient = CPTGradient(
                beginning: gradientBeginingColor,
                ending: gradientEndColor)
            lineGradient.angle = 90
            lineStyle.lineFill = CPTFill(gradient: lineGradient)
            dataSourceLinePlot.dataLineStyle = lineStyle
        }
        
        // create and set datasource
        let chartDataSource = StepsChartViewDataSource(stepsReports: stepsReports)
        dataSourceLinePlot.dataSource = chartDataSource
        self.chartDataSource = chartDataSource
        // add plot to graph
        graph.add(dataSourceLinePlot)
        
        hostingView.hostedGraph = graph
    }
    
}
