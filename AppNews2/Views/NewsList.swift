//
//  NewsList.swift
//  AppNews2
//
//  Created by Nazildo Souza on 19/09/20.
//

import SwiftUI

struct NewsList: View {
    @StateObject var newsState = NewsListState()
    @State private var newsLink: News.Articles?
    @State private var showSearch = false
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)) {
            
            ScrollView {
                Spacer().frame(height: 70)

                LoadingView(isLoading: self.newsState.isLoading, error: self.newsState.error) {
                    self.newsState.loadNews(witch: .topHeadlines)
                }.padding(.all)
                
                if newsState.news != nil {
                    ForEach(self.newsState.news!, id: \.title) { news in
                        
                        Button {
                            newsLink = news
                        } label: {
                            NewRow(article: news)
                                .padding(.horizontal)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                    }
                    .fullScreenCover(item: self.$newsLink) { link in
                        SafariView(url: link.url!).ignoresSafeArea()
                    }
                }
                
                HStack {
                    Button(action: {
                        self.newsState.pageUpOrDown = false
                        self.newsState.page -= 1
                        self.newsState.loadNews(witch: .topHeadlines)
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
                        self.newsState.loadNews(witch: .topHeadlines)
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

            GeometryReader { geo in
                
                VStack {
                    Text("App News")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                        .padding(.bottom)
                }
                .frame(width: geo.size.width)
                .background(BlurView(style: .systemMaterial).clipShape(Corners(corner: [.bottomLeft, .bottomRight], size: CGSize(width: 20, height: 20))).edgesIgnoringSafeArea([.top, .horizontal]).shadow(radius: 3))
                
            }
            
            if showSearch {
                NewsSearchList()
            }
            
            Button(action: {
                showSearch.toggle()
            }, label: {
                Image(systemName: showSearch ? "xmark" : "magnifyingglass")
                    .imageScale(.large)
            })
            .padding(.all, 8)
            .padding(.trailing, 30)
            .padding(.top, 10)
            
        }
        .onAppear {
            self.newsState.loadNews(witch: .topHeadlines)
        }
    }
}

struct NewsList_Previews: PreviewProvider {
    static var previews: some View {
        NewsList()
    }
}
