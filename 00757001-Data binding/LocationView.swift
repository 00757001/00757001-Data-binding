//
//  LocationView.swift
//  00757001-Data binding
//
//  Created by User12 on 2020/10/28.
//

import SwiftUI

struct LocationView: View {
    @Binding var showSheet : Bool
    @Binding var area : Int
    @Binding var distance : Double
    @Binding var time : Double //去程時間
    var hour : Int
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(alignment: .leading) {
                Text("推薦景點")
                    .fontWeight(.bold)
                    .font(.system(size: 40))
                    .offset(x:7,y:20)
                Divider()
                PickerView(area: self.area, distance: self.distance, time: self.time, hour: self.hour)
                
            }
            Button(action: {
                self.showSheet.toggle()
            }){
                Image(systemName: "xmark.circle.fill")
                    .scaleEffect(1.5)
                    .position(x:380,y:0)
            }.buttonStyle(PlainButtonStyle())
        }
    }
}

struct PickerView: View{
    var area: Int
    var distance: Double
    var time: Double
    var hour : Int
    let Areas = [keelung,ruifang,wanli]
    
    
    var body: some View{
        let pick = self.choose(area: area, distance: distance, time: time, hour: hour)
        return VStack{
            introductionView(place: Areas[area][pick])
        }

    }
    
    func choose(area: Int, distance: Double, time: Double, hour : Int) -> Int{
        var qualified : [Int] = []
        var DistanceDiffer : Double = 100.0
        var choice : Int
        
        if(distance == 0 || time == 0){
            choice = Int.random(in: 0..<Areas[area].count)
            return choice
        }
        
        else{
            for i in 0..<Areas[area].count{ //先找出最接近的距離
                if DistanceDiffer >= abs(Areas[area][i].distance - distance) && Areas[area][i].hour >= hour{
                    DistanceDiffer = abs(Areas[area][i].distance - distance)
                }
            }
            
            for i in 0..<Areas[area].count{
                if(DistanceDiffer == abs(Areas[area][i].distance - distance)) {
                    qualified.append(i)
                }
            }
            choice = qualified.randomElement()!
            return choice
        }
    }
}



struct introductionView: View{
    let place : location
    @State private var showMap = false
    
    var body: some View{
        VStack{
            ScrollView(){
                Image(place.photo)
                    .resizable().scaledToFit()
                Text(place.name)
                    .font(.system(size: 30))
                    .fontWeight(.bold)
                Section(header: CustomHeader(name: "簡介")){
                    Text(place.description)
                        .padding()
                        .font(.system(size: 22))
                        .frame(width:410)
                        
                }
                Section(header: CustomHeader(name: "地址")){
                    Text(place.address)
                        .padding()
                        .font(.title2)
                        
                }
                Section(header: CustomHeader(name: "經緯度")){
                    Text("\(place.latitude) / \(place.longitude)")
                        .padding()
                        .font(.title2)
                        
                }
                Button(action:{
                    showMap = true
                }){
                    HStack{
                        Image(systemName: "map.fill").scaleEffect(2)
                        Text("  查看地圖").font(.title2)
                    }
                }.buttonStyle(PlainButtonStyle())
                .foregroundColor(.blue)
                .fullScreenCover(isPresented: $showMap){
                    MapView(showMap: $showMap,name: place.name ,latitude: place.latitude, longitude: place.longitude)
                }
            }
        }
    }
}


struct CustomHeader: View {
    let name: String
    var body: some View {
        ZStack {
            Color(red: 84/255, green: 153/255, blue: 150/255).edgesIgnoringSafeArea(.all)
            HStack {
                Text(name)
                    .font(.system(size: 25))
                    .bold()
                    .foregroundColor(Color.black)
                Spacer()
            }
            .frame(width: 370)
            Spacer()
        }.frame(width:410, height: 33)
    }
}



struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(showSheet: .constant(true), area: .constant(1), distance: .constant(30), time: .constant(1), hour: 18)
    }
}
