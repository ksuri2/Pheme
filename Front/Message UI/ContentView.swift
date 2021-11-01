//  Pheme
//  Message, Contact, Setttings Page

import SwiftUI
import CoreImage.CIFilterBuiltins


// Create the base view
struct ContentView: View {
    
    var body: some View {
        
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


// This determines which part of homepage is displayed
struct Home : View {
    
    @State var index = 1
    @State var expand = false
    
    var body : some View{
        
        ZStack{
            
            VStack{
                
                Color.white
                Color("Color")
            }
            
            VStack{
                // checks Messages, Contacts, Settings
                ZStack{
                    
                    Messages(expand: self.$expand).opacity(self.index == 0 ? 1 : 0)
                    
                    Contacts(expand: self.$expand).opacity(self.index == 1 ? 1 : 0)
                    
                    Settings().opacity(self.index == 2 ? 1 : 0)
                }
                
                BottomView(index: self.$index)
                
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct BottomView : View {
    
    @Binding var index : Int
    
    var body : some View{
        
        HStack{
            
            Button(action: {
                
                self.index = 0
                
            }) {
                
                Image(systemName: "message.fill")
                .resizable()
                .frame(width: 25, height: 25)
                    .foregroundColor(self.index == 0 ? Color.white : Color.white.opacity(0.5))
                .padding(.horizontal)
            }
            
            Spacer(minLength: 10)
            
            Button(action: {
                
                self.index = 1
                
            }) {
                
                Image(systemName: "person.2.fill")
                .resizable()
                .frame(width: 28, height: 25)
                .foregroundColor(self.index == 1 ? Color.white : Color.white.opacity(0.5))
                .padding(.horizontal)
            }
            
            Spacer(minLength: 10)
            
            Button(action: {

                self.index = 2

            }) {

                Image(systemName: "gearshape.fill")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(self.index == 2 ? Color.white : Color.white.opacity(0.5))
                .padding(.horizontal)
            }
            
        }.padding(.horizontal, 30)
        .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
    }
}

struct shape : Shape {
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.bottomLeft,.bottomRight], cornerRadii: CGSize(width: 30, height: 30))
        
        return Path(path.cgPath)
    }
}




/*
Everything we need for the Messages page
 - struct Messages
 - struct chatTopView
 - struct messagesCentertview
 - struct cellMessagesView
*/

struct Messages : View {

    @Binding var expand : Bool
    
    var body : some View{
        
        VStack(spacing: 0){
            
            chatTopView(expand: self.$expand).zIndex(25)
            
            messagesCenterview(expand: self.$expand).offset(y: -25)
        }
    }
}

struct chatTopView : View {
    
    @State var username: String = "abc"
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()
    
    @State var search = ""
    @Binding var expand : Bool
    
    var body : some View{
        
        VStack(spacing: 22){
            
            if self.expand{
                
                HStack{
                    
                    Text("Messages")
                        .fontWeight(.bold)
                        .font(.title)
                        .foregroundColor(Color.black.opacity(0.7))
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }) {
                        
                        Image("menu")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.black.opacity(0.4))
                    }
                }
                
                Image(uiImage: generateQRCode(from: "\(username)"))
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()
                
            }
            
            HStack(spacing: 12){
                
                Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 18, height: 18)
                .foregroundColor(Color.black.opacity(0.3))
                
                TextField("Search Messages...", text: self.$search)
                
            }.padding()
            .background(Color.white)
            .cornerRadius(8)
            .padding(.bottom, 5)
            
        }.padding()
        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
        .background(Color("Color1"))
        .clipShape(shape())
        .animation(.default)
        
    }
    
    func generateQRCode(from string: String) -> UIImage {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")

        if let outputImage = filter.outputImage{
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent){
                return UIImage(cgImage: cgimg)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

struct messagesCenterview : View {
    
    @Binding var expand : Bool
    
    var body : some View{
        
        List(data){i in
            
            if i.id == 0{
                
                cellMessagesView(data : i)
                .onAppear {
                        
                    self.expand = true
                }
                .onDisappear {
                    
                    self.expand = false
                }
            }
            else{
                
                cellMessagesView(data : i)
            }
            
        }
        .padding(.top, 5)
        .background(Color.white)
        .clipShape(shape())
    }
}

struct cellMessagesView : View {
    
    var data : Msg
    
    var body : some View{
        
        HStack(spacing: 12){
            
            Image(data.img)
            .resizable()
            .frame(width: 55, height: 55)
            
            VStack(alignment: .leading, spacing: 12) {
            
                Text(data.name)
                
                Text(data.msg).font(.caption)
            }
            
            Spacer(minLength: 0)
            
            VStack{
                
                Text(data.date)
                
                Spacer()
            }
        }.padding(.vertical)
    }
}

/*
Everything needed for the Contact page
 - struct Contacts
 - struct contactTopView
*/

struct Contacts : View {
    
    @Binding var expand : Bool
    
    var body : some View{
        
        VStack(spacing: 0){
            
            contactTopView(expand: self.$expand).zIndex(25)
            
            contactsCenterview(expand: self.$expand).offset(y: -25)
        }
    }
}

struct contactTopView : View {
    
    @State var search = ""
    @Binding var expand : Bool
    
    var body : some View{
        
        VStack(spacing: 22){
            
            if self.expand{
                
                HStack{
                    
                    Text("Contacts")
                        .fontWeight(.bold)
                        .font(.title)
                        .foregroundColor(Color.black.opacity(0.7))
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }) {
                        
                        Image("menu")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.black.opacity(0.4))
                    }
                }
                
            }
            
            HStack(spacing: 12){
                
                Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 18, height: 18)
                .foregroundColor(Color.black.opacity(0.3))
                
                TextField("Search Contacts...", text: self.$search)
                
            }.padding()
            .background(Color.white)
            .cornerRadius(8)
            .padding(.bottom, 5)
            
        }.padding()
        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
        .background(Color("Color1"))
        .clipShape(shape())
        .animation(.default)
        
    }
}

struct contactsCenterview : View {
    
    @Binding var expand : Bool
    
    var body : some View{
        
        List(contact_list){i in
            
            if i.id == 0{
                
                cellContactView(contact_list : i)
                .onAppear {
                        
                    self.expand = true
                }
                .onDisappear {
                    
                    self.expand = false
                }
            }
            else{
                
                cellContactView(contact_list : i)
            }
            
        }
        .padding(.top, 5)
        .background(Color.white)
        .clipShape(shape())
    }
}

struct cellContactView : View {
    
    var contact_list : Contact
    
    var body : some View{
        
        HStack(spacing: 12){
            
            Image(contact_list.img)
            .resizable()
            .frame(width: 55, height: 55)
            
            VStack(alignment: .leading, spacing: 12) {
            
                Text(contact_list.name)
                
                Text("@" + contact_list.username).font(.caption)
            }
            
            Spacer(minLength: 0)
            
            VStack{
                
//                Text(data.date)
                
                Spacer()
            }
        }.padding(.vertical)
    }
}


struct Settings : View {
    
    @State var username: String = "abc"
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()
    
    var body : some View{
        
        GeometryReader{_ in
            
            VStack{
                
                Image(uiImage: generateQRCode(from: "\(username)"))
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()
                
            }
            
        }
        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
        .background(Color.white)
        .clipShape(shape())
        .padding(.bottom, 25)
    }
    
    func generateQRCode(from string: String) -> UIImage {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")

        if let outputImage = filter.outputImage{
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent){
                return UIImage(cgImage: cgimg)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }

}


/*
GLOBAL stuff
 - Msg (data)
 - Contact (contact_list)
*/

struct Msg : Identifiable {
    
    var id : Int
    var name : String
    var msg : String
    var date : String
    var img : String
}

struct Contact : Identifiable {
    var id : Int
    var public_key : Int
    var name : String
    var username : String
    var img : String
}

var data = [
    
    Msg(id: 0, name: "John Doe", msg: "Hey!", date: "10/30/21",img: "pic1"),
    Msg(id: 1, name: "Sarah L", msg: "How are you doing?", date: "10/30/21",img: "pic2"),
    Msg(id: 2, name: "Catherine C", msg: "yeah it was super fun", date: "10/29/21",img: "pic3"),
    Msg(id: 3, name: "Chris H", msg: "Hey", date: "10/18/21",img: "pic4"),
    Msg(id: 4, name: "Lina T", msg: "yeah I'm really enjoying the class", date: "10/17/21",img: "pic5"),
    Msg(id: 5, name: "Kate G", msg: "we could meet at the library", date: "10/17/21",img: "pic6"),
    Msg(id: 6, name: "Frank S", msg: "I'll take a look", date: "10/16/21",img: "pic7"),
    Msg(id: 7, name: "James O", msg: "Hello", date: "10/12/21",img: "pic8"),
    Msg(id: 8, name: "Becca", msg: "How are you?", date: "10/12/21",img: "pic9"),
    Msg(id: 9, name: "Brian L", msg: "awesome stuff!", date: "10/11/21",img: "pic10"),
    Msg(id: 10, name: "Julia U", msg: "Are you ready to go?", date: "09/24/21",img: "pic11"),
    Msg(id: 11, name: "Lauren A", msg: "glad you got it done", date: "09/16/21",img: "pic12"),
    
]

var contact_list = [
    
    
    Contact(id: 0, public_key: 0, name: "John Doe", username: "John.D", img: "pic1"),
    Contact(id: 1, public_key: 0, name: "Sarah L", username: "SarahL", img: "pic2"),
    Contact(id: 2, public_key: 0, name: "Catherine C", username: "CathyC", img: "pic3"),
    Contact(id: 3, public_key: 0, name: "Chris H", username: "Chris.H", img: "pic4"),
    Contact(id: 4, public_key: 0, name: "Lina T", username: "LinaT", img: "pic5"),
    Contact(id: 5, public_key: 0, name: "Kate G", username: "Katherine.G", img: "pic6"),
    Contact(id: 6, public_key: 0, name: "Frank S", username: "FrankS", img: "pic7"),
    Contact(id: 7, public_key: 0, name: "James O", username: "JamesO", img: "pic8"),
    Contact(id: 8, public_key: 0, name: "Becca", username: "Becky.W", img: "pic9"),
    Contact(id: 9, public_key: 0, name: "Brian L", username: "BrianL", img: "pic10"),
    Contact(id: 10, public_key: 0, name: "Julia U", username: "JuliaU", img: "pic11"),
    Contact(id: 11, public_key: 0, name: "Lauren A", username: "Lauren.a", img: "pic12"),
]
