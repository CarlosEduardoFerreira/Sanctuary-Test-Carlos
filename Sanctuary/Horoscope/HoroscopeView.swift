//
//  GalleryView.swift
//  PuppyGram
//
//  Created by Carlos Ferreira on 9/2/22.
//

import SwiftUI

struct HoroscopeView: View {
    
    @ObservedObject var viewModel = HoroscopeViewModel()
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
    
    @State var showSheet = false
    @State var currentSign = HoroscopeModel(sign: nil, horoscopes_in_response: 0)
    @State var currentPeriod = HoroscopeViewModel.Period.Daily
    
    var body: some View {
        VStack {
            HStack {
                Image(uiImage: UIImage(named: "AppIcon")!)
                    .resizable()
                    .padding(10)
                    .frame(width: 60, height: 60)
                    .aspectRatio(contentMode: .fit)
                
                Text("Sanctuary")
                    .padding(10)
                    .font(.system(size: 26))
                    .foregroundColor(.black)
            }
            
            HStack(alignment: .center) {
                TabButton(viewModel: viewModel, period: .Daily, currentPeriod: $currentPeriod)
                
                Spacer().frame(width: 150)
                
                TabButton(viewModel: viewModel, period: .Monthly, currentPeriod: $currentPeriod)
            }
            
            Spacer()
                
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(viewModel.horoscopes, id:\.self) { sign in
                        ZStack(alignment: .topTrailing) {
                            
                            SignCell(sign: sign, showSheet: $showSheet) {
                                currentSign = sign
                                showSheet.toggle()
                            }
                            .cornerRadius(8)
                            .padding(.top, 18)
                            .padding(.trailing, 18)
                            .fullScreenCover(isPresented: $showSheet) {
                                SheetView(viewModel: viewModel, currentSign: $currentSign, showSheet: $showSheet)
                            }
                        }
                    }
                }
                .padding([.leading,.top], 12)
            }
        }
    }
    
    
    struct SignCell: View {
   
        var sign: HoroscopeModel
        
        @Binding var showSheet: Bool
        
        var action: () -> Void
        
        var body: some View {
            Button(action: action) {
                VStack() {
                    Image(uiImage: UIImage(named: sign.sign!)!)
                    .resizable()
                    .background(Color.white)
                    .padding(12)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100, alignment: .center)
                    
                    Text(sign.sign?.capitalized ?? "")
                        .font(.system(size: 18))
                        .padding([.bottom,.horizontal], 12)
                        .foregroundColor(.black)
                    
                    Spacer()
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.gray, lineWidth: 1)
            )

        }
    }

    
    struct SheetView: View {
        @Environment(\.presentationMode) var presentationMode
        
        var viewModel: HoroscopeViewModel
        @Binding var currentSign: HoroscopeModel
        @Binding var showSheet: Bool
        
         var body: some View {
        
             VStack {
                 HStack {
                    Spacer().frame(width: 90)

                    Button {
                       presentationMode.wrappedValue.dismiss()
                     } label: {
                        Image(systemName: "xmark.circle")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                     }
                     .frame(maxWidth: .infinity, alignment: .trailing)
                 }
                 
                 VStack {
                     HStack {
                         Image(uiImage: UIImage(named: currentSign.sign!)!)
                             .resizable()
                             .padding(10)
                             .aspectRatio(contentMode: .fit)
                         
                         Text(currentSign.sign?.capitalized ?? "")
                             .font(.system(size: 40))
                             .padding([.bottom], 6)
                             .foregroundColor(.black)
                             .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                     }
                     .frame(maxWidth: .infinity, maxHeight: 100, alignment: .top)
                     
                     ScrollView {
                             ForEach(currentSign.payload ?? [], id:\.self) { payload in
                                 VStack() {
                                     Text(payload.date ?? "")
                                         .bold()
                                         .font(.system(size: 16))
                                         .padding([.bottom], 6)
                                         .foregroundColor(.black)
                                         .padding(.top, 16)
                                         
                                     
                                     Text(payload.horoscope ?? "")
                                         .font(.system(size: 14))
                                         .padding([.bottom], 6)
                                         .foregroundColor(.black)
                                 }
                             }
                     }
                 }
           }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding()
       }
    }
    
    struct TabButton: View {
        var viewModel: HoroscopeViewModel
        var period: HoroscopeViewModel.Period
        @Binding var currentPeriod: HoroscopeViewModel.Period
        
        var body: some View {
            Button {
                currentPeriod = period
                viewModel.reload(period: period)
             } label: {
                 Text(period.rawValue.capitalized)
                     .font(currentPeriod == period ? Font.headline.weight(.bold) : .system(size: 20))
                     .foregroundColor(currentPeriod == period ? .black : .gray)
             }
             .padding(.vertical, 10)
             .frame(maxWidth: 110)
        }
    }
    
}


struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        HoroscopeView(currentPeriod: .Daily).environmentObject(HoroscopeViewModel())
    }
}
