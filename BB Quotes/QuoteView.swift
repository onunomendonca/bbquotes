//
//  QuoteView.swift
//  BB Quotes
//
//  Created by Nuno Mendonça on 06/06/2023.
//

import SwiftUI

struct QuoteView: View {
    
    @StateObject private var viewModel = ViewModel(controller: FetchController())
    let show: String
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(show.lowerNoSpaces)
                    .resizable()
                    .frame(width: geo.size.width * 2.7, height: geo.size.height * 1.2)
                
                VStack {
                    VStack {
                        
                        Spacer(minLength: 140)
                        
                        switch viewModel.status {
                            
                        case .success(let data):
                            Text("\"\(data.quote.quote)\"")
                            // Para quando tem muito texto ele diminuir a fonte.
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding()
                                .background(.black.opacity(0.5))
                                .cornerRadius(25)
                                .padding(.horizontal)
                            
                            ZStack(alignment: .bottom) {
                                
                                //Whenever we fetch data async then use AsyncImage instead of Image.
                                AsyncImage(url: data.character.images[0]) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: geo.size.width / 1.1, height: geo.size.height / 1.8)
                                
                                
                                Text(data.character.name)
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .frame(maxWidth: .infinity)
                                    .background(.ultraThinMaterial)
                            }
                            .frame(width: geo.size.width / 1.1, height: geo.size.height / 1.8)
                            .cornerRadius(80)
                            
                        case .fetching:
                            ProgressView()
                            
                        default:
                            EmptyView()
                        }
                        Spacer()
                    }
                    
                    //A view tem que tar inside da label. Para que tudo seja botao.
                    // Se eu fizer os modifiers fora do botao, a area de atuaçao
                    // é apenas o texto.
                    Button {

                        // The view is always running on the main thread. So everything has to work with that. Async func don't work with that very well. The getData is async.
                        // So we wrap it in a Task that works with async code.
                        Task {
                            await viewModel.getData(for: show)
                        }
                    } label: {
                        Text("Get Random Quote")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("\(show.noSpaces)Button"))
                            .cornerRadius(7)
                            .shadow(color: Color("\(show.noSpaces)Shadow"), radius: 2)
                    }
                    
                    Spacer(minLength: 180)
                    
                }.frame(width: geo.size.width)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
    }
}

struct QuoteView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteView(show: Constants.bbName)
            .preferredColorScheme(.dark)
    }
}
