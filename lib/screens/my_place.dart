import 'package:gotour_mobile/screens/add_place_form.dart';
import 'package:gotour_mobile/widgets/place_card.dart';
import 'package:flutter/material.dart';

import '../services/places.dart';

class MyPlaces extends StatefulWidget {
  const MyPlaces({Key? key}) : super(key: key);

  @override
  State<MyPlaces> createState() => _MyPlacesState();
}

class _MyPlacesState extends State<MyPlaces> {
  late Future<List<Place>> _myPlaces;

  @override
  void initState() {
    super.initState();
    _myPlaces = fetchMyPlaces();
  }

  void refreshList(int id) {
    // reload
    setState(() {
      _myPlaces = _deleteAndGetPlaces(id);
    });
  }

  Future<List<Place>> _deleteAndGetPlaces(int id) async {
    await deletePlace(id);
    List<Place> newMyPlaces = await fetchMyPlaces();
    const snackBar = SnackBar(
      content: Text('Place has been deleted.'),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    return newMyPlaces;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Places',
          style: TextStyle(color: Colors.teal),
        ),
        elevation: 0,
        backgroundColor: Colors.grey[50],
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddPlaceForm()),
                );
              },
              icon: const Icon(
                Icons.add_box_outlined,
                color: Colors.teal,
              )),
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: FutureBuilder<List<Place>>(
          future: _myPlaces,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 5),
                      child: PlaceCard(
                        id: snapshot.data![index].id,
                        isCarousel: false,
                        isMyPlace: true,
                        imgUrl: snapshot.data![index].imgUrl,
                        location: snapshot.data![index].location,
                        name: snapshot.data![index].name,
                        description: snapshot.data![index].description,
                        rating: double.parse(snapshot.data![index].rating),
                        ratingCount: snapshot.data![index].ratingCount,
                        isWishlisted: snapshot.data![index].isWishlisted,
                        refreshList: refreshList,
                      ),
                    );
                  });
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            // By default, show a loading spinner.
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
