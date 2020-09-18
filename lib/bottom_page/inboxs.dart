import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pelanggan/bottom_page/file_inbox/bloc.dart';

class Inboxs extends StatefulWidget {
  
  Inboxs({Key key, this.dataP}) : super(key: key);
  final Map<String, dynamic> dataP; 
  @override
  _InboxsState createState() => _InboxsState();
}

class _InboxsState extends State<Inboxs> {
  MovieListBloc movieListBloc;
 
  ScrollController controller = ScrollController();

  @override
  void initState() {
    
    super.initState();
    movieListBloc = MovieListBloc();
    movieListBloc.fetchFirstList();
    controller.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
          brightness : Brightness.light,
         title: Text('Inbox',style: TextStyle(color: Colors.black ),),  
      ),
      body: StreamBuilder<List<DocumentSnapshot>>(
        stream: movieListBloc.movieStream,
        builder: (context, snapshot) { 
            if (snapshot.hasError) {
             return     Center( 
                  child:Container(  color: Colors.white,
                    padding:   const EdgeInsets.all( 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                          ClipRRect(
                            borderRadius:  BorderRadius.circular(8.0),
                            child:  Image.asset(
                              'assets/images/no_inbox.png',
                              // height: 172.0,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ), 
                        Text( 'Data pesan masuk akan muncul disini.'),
                      ],
                    )
                  ) 
                ); 
            } else if (snapshot.data != null) {
              
                return ListView.builder(
                itemCount: snapshot.data.length,
                shrinkWrap: true,
                controller: controller,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                          leading:Icon(  Icons.drafts,
                            size: 32.0,  color: Colors.orange,
                          ),
                          title: Text(snapshot.data[index]['title'] , maxLines: 2,), 
                          subtitle: Column( 
                                crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[ 
                                Text(snapshot.data[index]['message']  ), 
                                SizedBox(height: 16,),
                                Text(snapshot.data[index]['tag']),    
                              ],
                            ), 
                          
                        ),
                      /*ListTile(
                        leading: CircleAvatar(
                            child: Text(snapshot.data[index]["title"].toString())),
                        title: Text(snapshot.data[index]["title"]),
                      ),*/

                    ),
                  );
                },
              );
           
            } else {
              return Center(
                child: CircularProgressIndicator() 
              );  
            }
        },
      ),
    );
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      print('at the end of list');
      movieListBloc.fetchNextMovies();
    }
  }
}