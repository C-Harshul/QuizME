import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class QCards extends StatefulWidget {
  @override
  _QCardsState createState() => _QCardsState();
}

class _QCardsState extends State<QCards> {
  Stream cards;
  int currentCard = 0;
  String user;

 final PageController qCtrl =PageController();
 @override
 Future<String> getTag() async{
   final email = await FirebaseAuth.instance.currentUser();
   user = email.email;
   String temp = '';
   for (int i=0;i<user.length;++i){
     if(user[i]=='@')
       break;
     else
       temp = temp + user[i];
   }
   user = temp;
   print(user);
   return user;
 }
  void initState() {
    getTag();
    queryDb();
    qCtrl.addListener(() {
      int next = qCtrl.page.round();
      if(currentCard != next){
        setState(() {
          currentCard =next;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar:AppBar(
         title: Text('  QuizME',
         style: TextStyle(
           fontFamily: 'Marker',
           fontSize:50,
           color: Color(0xFFEB1555)
         ),
         ),
       ),
       drawer: Drawer(
         child:Container(
             color: Color(0xFF0A0E21),
             child:ListView(
               children: <Widget>[
                 DrawerHeader(
                   margin: EdgeInsets.only(left:10,right:10),
                   child: Center(
                     child: Text(
                       'Jump TO',
                       style:TextStyle(
                           color:Color(0xFFEB1555),
                           fontSize: 30,
                           fontFamily: 'Marker'
                       ),
                     ),
                   ),
                   decoration: BoxDecoration(
                       color: Color(0xFF1D1E33),
                       borderRadius: BorderRadius.circular(20)
                     /*image: DecorationImage(
                      fit: BoxFit.cover,
                      image:NetworkImage('https://images6.alphacoders.com/548/thumb-1920-548302.jpg')
                    )*/
                   ),
                 ),
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: ListTile(
                     leading: Icon(Icons.bookmark,color: Color(0xFFEB1555),),
                     title: Text(
                       '   Review',
                       style: TextStyle(
                           color:Colors.white,
                           fontSize: 25,
                           fontFamily: 'Anton'
                       ),
                     ),
                     onTap: (){
                       queryDb(tag: 'review');
                       Navigator.of(context).pop();
                       setState(() {

                       });
                     },
                   ),
                 ),
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: ListTile(
                     leading: Icon(Icons.bookmark,color: Color(0xFFEB1555),),
                     title: Text(
                       '   All',
                       style: TextStyle(
                           color:Colors.white,
                           fontSize: 25,
                           fontFamily: 'Anton'
                       ),
                     ),
                     onTap: () {
                       queryDb();
                       Navigator.of(context).pop();
                       setState(() {

                       });
                     },
                   ),
                 )
               ],
             )
         ),
       ),
       backgroundColor: Color(0xFF0A0E21),
       body: StreamBuilder(
         stream : cards,
         // ignore: missing_return
         builder: (context ,AsyncSnapshot snap){

          if(snap.hasData){
            List cardList = snap.data.toList();
            return PageView.builder(
              controller: qCtrl,
              itemCount: cardList.length,
              // ignore: missing_return
              itemBuilder: (context, int crrntIndex){
                bool active = crrntIndex == currentCard ;
                return _buildCard(cardList[crrntIndex],active,cardList[crrntIndex]['code']);
              },
            );
          }
          else
              return CircularProgressIndicator();
         }
       ),
     );
  }
  Future<Stream> queryDb({String tag = 'all'}) async{
    user = await getTag();
    Query query = Firestore.instance.collection('QuizME').where('$user',arrayContains: tag);
    cards = query.snapshots().map((list) => list.documents.map((doc) => doc.data));
    setState(() {

    });
 }

  _buildCard(Map data, bool active, String ID ){
   final double blur = active?30:0;
   final double offset = active?20:0;
   final double top = active? 20:200;
   final myController = TextEditingController();
   final bool bookmark = data['$user'].contains('review');
   Map answers = data['Answers'];
   myController.text= answers['$user'];
   return AnimatedContainer(
     child: SingleChildScrollView(
       child: Column(
         children: <Widget>[
           Container(
             padding: EdgeInsets.all(20),
             child: Text(
               data['Question'],
               style: TextStyle(
                 color: Colors.white,
                 fontSize: 20,
               ),
             ),
           ),
           Padding(
             padding: const EdgeInsets.only(left:20.0,right: 20.0,bottom: 10),
             child: Container(
               height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image:DecorationImage(
                  fit:BoxFit.cover,
                  image:NetworkImage(data['img']),
                )
              ),
             ),
           ),
          Padding(
            padding: const EdgeInsets.only(left:9,right:9),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFEB1555) ,
                borderRadius: BorderRadius.circular(10.0)
              ),
              child: Padding(
                padding: const EdgeInsets.only(left:8.0),
                child: TextField(
                  controller:myController ,
                  style: TextStyle(
                    color: Color(0xFF1D1E33),
                  ),
                  decoration: InputDecoration(
                   hintText: 'Answer',
                   hintStyle: TextStyle(
                     color: Colors.black,
                   ),
                   border: InputBorder.none,
                 ),
                ),
              ),
            ),
          ),
         Container(
           margin: EdgeInsets.only(left:15,top: 5,bottom: 5),
           height: 50,
           decoration: BoxDecoration(
             color: Color(0xFF1D1E33),
             borderRadius: BorderRadius.only(bottomRight: Radius.circular(20),bottomLeft: Radius.circular(20))
           ),
           child:Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: <Widget>[
               InkWell(
                 onTap: () async{
                   final ans = myController.text;
                   print(ID);
                   Map answers = {};
                   setState(() {
                     answers = data['Answers'];
                     answers['$user'] = ans;
                   });
                   await Firestore.instance.collection('QuizME').document('$ID').updateData({'Answers':answers});
                },
                 child: Text('Submit',
                 style:TextStyle(
                    color: Colors.white
                  ) ,
                 ),
               ),
               IconButton(
                 icon: Icon(Icons.bookmark,color: bookmark? Color(0xFFEB1555):Colors.white),
                 onPressed: ()async{
                   List tags = data['$user'];
                   if(!tags.contains("review")){
                     setState(() {
                       tags.add('review');
                     });
                   }
                   else
                     setState(() {
                       tags.remove('review');
                     });
                   await Firestore.instance.collection('QuizME').document('$ID').updateData({'$user':tags});
                 },
               )
             ],
           ),
          )
         ],
       ),
     ),
     duration: Duration(milliseconds: 500),
     curve: Curves.easeOutQuint,
     margin: EdgeInsets.only(top:top,bottom:50,right:30,left: 30),
     decoration: BoxDecoration(
       borderRadius: BorderRadius.circular(20),
       color: Color(0xFF1D1E33),
       boxShadow:[BoxShadow(blurRadius:blur)]
     ),
   );
  }
}


