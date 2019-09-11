import 'all.dart';
import 'PhotoItem.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GridImageStyle _tileStyle = GridImageStyle.twoLine;

  List<Photo> photos = <Photo>[
    Photo(
      assetName: 'places/india_chennai_flower_market.png',
      assetPackage: 'grid_list_image_comment_assets',
      title: 'Chennai',
      caption: 'Flower Market',
    ),
    Photo(
      assetName: 'places/india_tanjore_bronze_works.png',
      assetPackage: 'grid_list_image_comment_assets',
      title: 'Tanjore',
      caption: 'Bronze Works',
    ),
  ];
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SafeArea(
              top: false,
              bottom: false,
              child: GridView.count(
                crossAxisCount: 2,// (orientation == Orientation.portrait) ? 2 : 3,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                padding: const EdgeInsets.all(4.0),
                childAspectRatio: 1.0,// (orientation == Orientation.portrait) ? 1.0 : 1.3,
                children: photos.map<Widget>((Photo photo) {
                  return GridDemoPhotoItem(
                    photo: photo,
                    tileStyle: _tileStyle,
                    onBannerTap: (Photo photo) {
                      setState(() {
                        photo.isFavorite = !photo.isFavorite;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
