import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gotour_mobile/screens/auth.dart';
import 'package:gotour_mobile/services/places.dart';
import 'package:gotour_mobile/services/user_auth.dart';
import 'package:gotour_mobile/widgets/place_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Place>> _mostRatedPlaces;
  late Future<List<Place>> _recentPlaces;

  @override
  void initState() {
    super.initState();
    _mostRatedPlaces = fetchPlaces(1, "", "rating");
    _recentPlaces = fetchPlaces(1, "", "created_at");
  }

  void logout(BuildContext context) async {
    final response = await logoutUser();
    if (response == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Logged out succesfully'),
      ));
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const AuthScreen(),
        ),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/home_logo.png'),
        backgroundColor: Colors.grey[50],
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () => logout(context),
              icon: const Icon(
                Icons.logout,
                color: Colors.teal,
              )),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              child: const Text(
                'Most Rated',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
              ),
            ),
            FutureBuilder<List<Place>>(
                future: _mostRatedPlaces,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return CarouselSlider(
                      options: CarouselOptions(height: 215.0),
                      items: (snapshot.data as List).take(4).map((place) {
                        return PlaceCard(
                          id: place.id,
                          isCarousel: true,
                          isMyPlace: false,
                          imgUrl: place.imgUrl,
                          location: place.location,
                          name: place.name,
                          description: place.description,
                          rating: double.parse(place.rating),
                          ratingCount: place.ratingCount,
                          isWishlisted: place.isWishlisted,
                        );
                      }).toList(),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  // By default, show a loading spinner.
                  return const Center(child: CircularProgressIndicator());
                }),
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: const Text(
                'Recently Added',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
              ),
            ),
            FutureBuilder(
                future: _recentPlaces,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return CarouselSlider(
                      options: CarouselOptions(height: 215.0),
                      items: (snapshot.data as List).take(4).map((place) {
                        return PlaceCard(
                          id: place.id,
                          isCarousel: true,
                          isMyPlace: false,
                          imgUrl: place.imgUrl,
                          location: place.location,
                          name: place.name,
                          description: place.description,
                          rating: double.parse(place.rating),
                          ratingCount: place.ratingCount,
                          isWishlisted: place.isWishlisted,
                        );
                      }).toList(),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  // By default, show a loading spinner.
                  return const Center(child: CircularProgressIndicator());
                }),
          ],
        ),
      ),
    );
  }
}
