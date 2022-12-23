import 'package:flutter/material.dart';
import 'package:music_app/feature/presentation/pages/player_page.dart';

void main() {
  runApp( MaterialApp(
    home: PlayerPage(
      genre: 'rock',
      imgUri: "https://d3d8y6yhucfd29.cloudfront.net/sports-product-image/dave-grohl-nirvana-signed-nevermind-album-cover-w-vinyl-autographed-bas-c15384-5-t7360022-500.jpg",
      info: "",
      name: "Smells like teen spirit",
      performer: "Nirvana",
      songUri: "https://muzgen.net/uploads/music/2021/09/Nirvana_Smells_Like_Teen_Spirit.mp3",
    ),
  )
  );
}
