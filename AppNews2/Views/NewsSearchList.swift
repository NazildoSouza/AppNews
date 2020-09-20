//
//  NewsList.swift
//  AppNews2
//
//  Created by Nazildo Souza on 19/09/20.
//

import SwiftUI

struct NewsSearchList: View {
    @StateObject var newsState = NewsSearchState()
    @State private var newsLink: News.Articles?
    
    var body: some View {
        
        ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
            Color(.systemBackground).ignoresSafeArea(.all, edges: .all)
            
            ScrollView {
                Spacer().frame(height: 130)
                
                LoadingView(isLoading: self.newsState.isLoading, error: self.newsState.error) {
                    self.newsState.startObserve()
                }.padding(.all)
                
                if newsState.news != nil {
                    ForEach(newsState.news!, id: \.title) { news in
                        Button {
                            newsLink = news
                        } label: {
                            NewRow(article: news)
                                .padding(.horizontal)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                
                if self.newsState.isEmptyResults {
                    Text("Sem Resultados")
                        .padding()
                    
                }
                
                if self.newsState.query.isEmpty {
                    Text("Busque por uma Notícia...")
                        .multilineTextAlignment(.center)
                        .padding()
                }
                
                HStack {
                    Button(action: {
                        self.newsState.pageUpOrDown = false
                        self.newsState.page -= 1
                        self.newsState.search(query: self.newsState.query)
                    }) {
                        Text("Anterior")
                            .font(.headline)
                            .fontWeight(.bold)
                            .opacity(self.newsState.page > 1 ? 1 : 0)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        self.newsState.pageUpOrDown = true
                        self.newsState.page += 1
                        self.newsState.search(query: self.newsState.query)
                    }) {
                        Text("Próximo")
                            .font(.headline)
                            .fontWeight(.bold)
                            .opacity(self.newsState.isTotalPages ? 1 : 0)
                    }
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 35)
                .opacity(self.newsState.isNewsCount ? 1 : 0)
            }
            
            VStack {
                Text("Busca")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                
                SearchBar(query: self.$newsState.query)
                    .padding(.top, 10)
                    .padding(.horizontal, 25)
                    .padding(.bottom)
            }
            .background(BlurView(style: .systemMaterial).clipShape(Corners(corner: [.bottomLeft, .bottomRight], size: CGSize(width: 20, height: 20))).edgesIgnoringSafeArea([.top, .horizontal]).shadow(radius: 3))
            
        }
        .fullScreenCover(item: self.$newsLink) { link in
            SafariView(url: link.url!).ignoresSafeArea()
        }
        .onAppear {
            self.newsState.startObserve()
        }
        
    }
}

struct NewsSearchList_Previews: PreviewProvider {
    static var previews: some View {
        NewsList()
    }
}

struct SearchBar: View {
    @Binding var query: String
    
    var body: some View {
        HStack {
            
            Image(systemName: "magnifyingglass")
                .padding(6)
            
            TextField("Buscar", text: $query)
            
            if !self.query.isEmpty {
                Button(action: {
                    
                    self.query = ""
                    
                }, label: {
                    Image(systemName: "xmark.circle")
                        .imageScale(.large)
                        .padding(.horizontal)
                })
            }
        }
        .padding(6)
        .background(Color(.tertiarySystemBackground))
        .cornerRadius(25)
        .shadow(radius: 2)
    }
}
