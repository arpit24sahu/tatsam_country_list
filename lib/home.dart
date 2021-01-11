import 'package:flutter/material.dart';
import 'main.dart';
import 'fav.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';
import 'dart:convert';

class Countries extends StatefulWidget {
  @override
  _CountriesState createState() => _CountriesState();
}

class _CountriesState extends State<Countries> {
  Map rest;
  List<Item> _countryList = [];

  Future<List<Item>> getData() async {
    String link = "https://api.first.org/data/v1/countries";
    var res = await http.get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    if (res.statusCode == 200) { //200 = Successful
      var data = json.decode(res.body);
      rest = data["data"];
      _countryList = _createList(rest);
    }
    return _countryList;
  }

  @override
  void initState() {
    _countryList = []; //Initialize the list to empty list
    getData(); //getting data from API
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: WillPopScope(
          onWillPop: (){ //to exit app when back is pressed
            print("App should exit now");
            exit(0);
            print("App should have");
          },
          child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Text("Country List"),
                centerTitle: true,
              ),
              body: FutureBuilder(
                  future: getData(),
                  builder: (context, snapshot){
                    return (snapshot.hasData)? //Checking if snapshot data has been loaded
                    Helper(items: snapshot.data): // If loaded
                    Center( //If not loaded
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(),
                          Text("Fetching Data...."),
                          Text(" "),
                          CircularProgressIndicator(),
                        ],
                      ),
                    );
                  }
              ),
              bottomNavigationBar: Material(
                color: Colors.transparent,
                child: RaisedButton(
                  color: Colors.yellow,
                  child: Text("Favorites", style: TextStyle(fontWeight: FontWeight.bold),),
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Favorites(data: rest,)
                        )
                    );
                  },
                ),
              )
          ),
        )
    );
  }
}

class Item{
  String code;
  Map data;
  Item({this.code, this.data});
}

//_createList function used to create a list of "Item" from the map
List<Item> _createList(Map map){
  List<Item> _list = [];
  for(var names in map.keys){
    _list.add( //generating list of countries
        Item(code: names, data: map[names],)
    );
  }
  return _list;
}


//Helper is used to generate a list of Widgets from a list of "Item" Objects
class Helper extends StatefulWidget {
  final List<Item> items;
  Helper({this.items});
  @override
  _HelperState createState() => _HelperState();
}

class _HelperState extends State<Helper> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (context,index){
          return Decorated(item: widget.items[index]);
        }
    );
  }
}

//Decorated Widget is used to set the Actual View of the ListTile
class Decorated extends StatefulWidget {
  final Item item;
  Decorated({this.item});
  @override
  _DecoratedState createState() => _DecoratedState();
}

class _DecoratedState extends State<Decorated> {
  Color _findColor(String code){ //Different color for favorites and non-favorites
    if(favorites.contains(code)) return Colors.red;
    else return Colors.blue;
  }
  Icon _findIcon(String code){ //Different Icon for favorites and non-favorites
    if(favorites.contains(code)) return Icon(Icons.favorite);
    else return Icon(Icons.favorite_border);
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(5), //Padding to ListTile
        child: Material(
          borderRadius: BorderRadius.circular(10),
          color: Colors.lightGreenAccent,
          child: ListTile(
              leading: CircleAvatar(
                child: Text(widget.item.code, style: TextStyle(fontWeight: FontWeight.bold),),
                backgroundColor: Colors.greenAccent,
              ),
              title: (widget.item.data["country"]!=null)?Text(widget.item.data["country"]):Text("null"), //null check
              subtitle: (widget.item.data["region"]!=null)?Text(widget.item.data["region"]):Text("null"), //null check
              trailing: IconButton(
                icon: _findIcon(widget.item.code),
                color: _findColor(widget.item.code),
                onPressed: (){
                  if(favorites.contains(widget.item.code)){
                    favorites.remove(widget.item.code);
                  }
                  else favorites.add(widget.item.code);
                  setState(() {

                  });
                },
              )
          ),
        )
    );
  }
}
