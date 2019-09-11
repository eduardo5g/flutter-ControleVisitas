import 'all.dart';
import 'PhotoItem.dart';

enum GridImageStyle {
  imageOnly,
  oneLine,
  twoLine
}
class GridImageList extends StatefulWidget {
  const GridImageList({ Key key }) : super(key: key);
  myPrint()=>print('Function myPrint inicio');
  
  static const String routeName = '/algo';
  @override
  BuildGridImage createState() => BuildGridImage();
}
class BuildGridImage extends State<GridImageList>{
    function()=>print('Declarando lista');

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

  void changeTileStyle(GridImageStyle value) {
    setState(() {
      _tileStyle = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Orientação do screen');
    // final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grid list'),
        actions: <Widget>[ 
          // MaterialDemoDocumentationButton(GridListDemo.routeName),
          PopupMenuButton<GridImageStyle>(
            onSelected: changeTileStyle,
            itemBuilder: (BuildContext context) => <PopupMenuItem<GridImageStyle>>[
              const PopupMenuItem<GridImageStyle>(
                value: GridImageStyle.imageOnly,
                child: Text('Image only'),
              ),
              const PopupMenuItem<GridImageStyle>(
                value: GridImageStyle.oneLine,
                child: Text('One line'),
              ),
              const PopupMenuItem<GridImageStyle>(
                value: GridImageStyle.twoLine,
                child: Text('Two line'),
              ),
            ],
          ),
        ],
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