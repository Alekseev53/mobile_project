//
//  controller.swift
//  Crypto
//
//  Created by Aleksandr Alekseev on 21.04.2024.
//
import SwiftUI
import SwiftUICharts
import WebKit
import Foundation

// Объект Модель
struct ChartDataModel: Identifiable {
    var id: Int
    var data: [Double]
    var color: Color
    var title: String
    var legend: String
}
struct User: Codable, Identifiable {
    var id: Int
    var name: String
    var email: String
}

var  size_of_data = 1000
var  my_disp = 0.01
var  my_last_n_elem = 1000.0

func generateRandomWalk_exp(steps: Int,disp: Double, last_n_elem: Double = 1000.0) -> [Double] {
    let last_n_elem = Int(last_n_elem)
    var last  = 0.0
    var data = [Double]()
    while last <= 0.1 {
        data = [Double]()
        for _ in 0..<steps {
            let randomStep = Double.random(in: -1...1)
            
            // Вычисление значения e в степени сгенерированного числа
            let stepSize = disp*randomStep+1+0.04/365+disp/365
            let lastStep = data.last ?? 1
            data.append(lastStep*stepSize)
        }
        last = data.last ?? 0.0
    }
    //return data
    // Возвращаем последние 100 элементов
    let end = data.count
    let start = end > last_n_elem ? end - last_n_elem : 0
    return Array(data[start..<end])
}

func generateRandomWalk(steps: Int) -> [Double] {
    var data = [Double]()
    for _ in 0..<steps {
        // Генерация числа с распределением Лапласа от -1 до 1
        let randomStep = Double.random(in: -1...1)
        let lastStep = data.last ?? 0
        data.append(lastStep + randomStep)
    }
    return data

}
