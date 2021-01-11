import 'package:flutter/material.dart';
import 'main.dart';

//Favorites Page
class Favorites extends StatefulWidget {
  final Map data; //The map passed to Favorites page from the home page
  Favorites({this.data});
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  List<Item> _favList = [];
  Future<List<Item>> _getData () async{
    var _favs = widget.data;
    _favList = _CreateFavList(_favs); //Calls the function that return list of favorite Items from the map
    return _favList;
  }

  @override
  void initState() {
    _getData(); //Initially getting data
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text("Favorites"),
              centerTitle: true,
            ),
            body: FutureBuilder(
                future: _getData(),
                builder: (context, snapshot){
                  return (snapshot.hasData)? //checking if snapshot data is loaded
                  (favorites.length!=0)? //checking if there is any fav country picked
                  FavHelper(items: snapshot.data): //yes there is a fav country
                  Column( //data loaded but no fav country picked
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(),
                      Text("Favorites List Empty", textScaleFactor: 1.2,),
                    ],
                  ):
                  Center(child: CircularProgressIndicator(), // data is loading
                  );
                }
            ),
            bottomNavigationBar: Material(
              color: Colors.transparent,
              child: RaisedButton(
                color: Colors.yellow,
                child: Text("All Countries", style: TextStyle(fontWeight: FontWeight.bold),),
                onPressed: (){ //route to the previous page
                  Navigator.pop(context); //Back button functionality
                },
              ),
            ),
        )
    );
  }
}

//FavHelper used to create the list of Widgets from a list of Items.
class FavHelper extends StatefulWidget {
  final List<Item> items;
  FavHelper({this.items});
  @override
  _FavHelperState createState() => _FavHelperState();
}

class _FavHelperState extends State<FavHelper> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (context,index){
          return DecoratedFav(item: widget.items[index]);
        }
    );
  }
}

//To create list of Fav countries as "Item"
List<Item> _CreateFavList(Map map){
  List<Item> _list = [];
  for(var names in map.keys){
    print("fav length: ${favorites.length}");
    if(favorites.contains(names)) { // checking for favorite countries
      _list.add(
          Item(code: names, data: map[names],)
      );
    }
  }
  return _list;
}

//Actual Widget that would be shown in the app
class DecoratedFav extends StatefulWidget {
  final Item item;
  DecoratedFav({this.item});
  @override
  _DecoratedFavState createState() => _DecoratedFavState();
}

class _DecoratedFavState extends State<DecoratedFav> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(5),
        child: Material(
          borderRadius: BorderRadius.circular(10),
          color: Colors.lightGreenAccent,
          child: ListTile(
            leading: Text(widget.item.code),
            title: Text(widget.item.data["country"]),
            subtitle: Text(widget.item.data["region"]),
          ),
        )
    );
  }
}
