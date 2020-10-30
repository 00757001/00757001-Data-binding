//
//  ContentView.swift
//  00757001-Data binding
//
//  Created by HungJie on 2020/10/27.
//

import SwiftUI

struct ContentView: View {
    init(){
            UITableView.appearance().backgroundColor = .clear
            UISegmentedControl.appearance().setTitleTextAttributes(
                [
                    .font: UIFont.systemFont(ofSize: 18),
                ], for: .normal)
        }
    let backgrounds = ["ㄧ","二","三"]
    @State private var name = ""
    @State private var showingAdvancedOptions = false
    @State private var Area = 0
    @State private var PredictTime = 0.0 // hours
    @State private var Distance = 0.0 //km
    @State private var RideTime = Date() //hour
    @State private var bgColor = Color.black
    @State private var backgroundIndex = 0
    @State private var showAlert1 = false
    @State private var showingActionSheet = false
    @State private var showingSheet = false
    
    var time: Int {Calendar.current.component(.hour, from: RideTime)}
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                VStack {
                    Text("騎車放風App")
                        .fontWeight(.bold)
                        .font(.system(size: 40))
                        .padding()
                        .position(x: 200, y: 50)

                    Form{
                        if !showingAdvancedOptions{
                            TextField("你的名字",text: $name)
                                .font(.system(size: 20))
                                .padding()
                                .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.black, lineWidth: 3))
                        }
                        
                        Toggle("GoGo", isOn : $showingAdvancedOptions.animation())
                            .font(.title)
                            .offset(x:5)
                        
                        if showingAdvancedOptions{
                            Text("      \(name)您好！\r\n今天要怎麼規劃呢？")
                                .font(.title3)
                                .offset(x:80)
                            VStack {
                                Text("前往地區")
                                    .font(.title2)
                                    .offset(x:-125)
                                PlacePicker(place: $Area)
                            }
                            DatePicker("出發時間", selection: $RideTime, displayedComponents: .hourAndMinute)
                                .font(.title2)
                            PredictTimeStepper(predict: $PredictTime)
                                .font(.title2)
                            DistanceSlider(distance: $Distance)
                            DisclosureGroup("程式個人化設定") {
                                ColorPicker("設定字體顏色", selection: $bgColor).font(.title2)
                                HStack {
                                    Text("背景  ")
                                    Picker("背景",selection: $backgroundIndex) {
                                        ForEach(0 ..< backgrounds.count) { (i) in
                                            Text(backgrounds[i])
                                        }
                                    }.pickerStyle(SegmentedPickerStyle())
                                }
                            }.font(.title2)
                            DisclosureGroup("關於") {
                               Text("根據使用者選出景點與海大之間的距離和出發的時間點來選出最合適的景點。")
                            }.font(.title2)
                        }
                    }.frame(height: 800)
                    .foregroundColor(bgColor)
                    .position(x:205,y:100)
                    
                    
                    if showingAdvancedOptions{
                        Button(action:{
                            if (PredictTime == 0.0 || Distance == 0){
                                showingActionSheet = true
                            }
                            else if(Area == 2 && time > 15){
                                showAlert1 = true
                            }
                            else{
                                showingSheet = true
                            }
                            
                        }){
                            HStack {
                                    Image(systemName: "car.fill")
                                        .font(.system(size: 40))
                                    Text("出發")
                                        .fontWeight(.semibold)
                                        .font(.system(size: 40))
                                }
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.red)
                                .cornerRadius(40)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .offset(y:0)
                        .actionSheet(isPresented: $showingActionSheet){
                            ActionSheet(title: Text("距離或時間為0"),message: Text("請問你要"),buttons: [
                            .default(Text("電腦幫你選")){ showingSheet = true },
                            .default(Text("自己選"))])
                        }
                        .alert(isPresented: $showAlert1) { () -> Alert in
                            return Alert(title: Text("警告"),message: Text("出發時間太晚囉！！"))
                        }
                        .fullScreenCover(isPresented: $showingSheet){
                            LocationView(showSheet: $showingSheet,area: $Area, distance: $Distance, time: $PredictTime, hour: time)
                        }
                    }
                }
            }
        }
        .background(Image("background"+"\(backgroundIndex)").resizable().scaledToFill().scaleEffect(1.1).offset(y:-6))
        .print(self.time)
    }
    
}

extension View {
    func print(_ value: Any) -> Self {
        Swift.print(value)
        return self
    }
}

struct PlacePicker: View {
    @Binding var place: Int
    
    let places=["基隆市","瑞芳平溪","北海岸",]

    var body: some View {
        Picker("地區",selection: $place){
            ForEach(0 ..< places.count) { (i) in
                Text(places[i])
                    .font(.system(size: 30))
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .scaleEffect(1.1)
        
    }
}

struct PredictTimeStepper: View {
    @Binding var predict: Double
    var body: some View {
        Stepper("騎車去程時間   " + "\(predict)小時", value: $predict, in: 0 ... 3,step:0.5)
    }
}

struct DistanceSlider: View {
    @Binding var distance: Double
    var body: some View {
        Slider(value: $distance, in: 0...48, step:3, minimumValueLabel: Text("距離"),maximumValueLabel:Text("\(Int(distance))公里")){}
            .font(.title2)
            .accentColor(.red)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
