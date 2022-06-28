import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:peliculas/screens/tabs/sinopsis_screen.dart';
import 'package:peliculas/screens/tabs/time_screen.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;

    return Scaffold(
      body: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                    title: Text(
                      movie.title,
                      style: TextStyle(fontSize: 16),
                    ),
                    backgroundColor: Colors.red,
                    expandedHeight: 200,
                    //floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      // titlePadding: EdgeInsets.all(0),
                      // centerTitle: true,
                      // title: Container(
                      //   padding: EdgeInsets.only(bottom: 50, left: 10, right: 10),
                      //   width: double.infinity,
                      //   alignment: Alignment.bottomCenter,
                      //   color: Colors.black12,
                      //   child: Text(
                      //     movie.title,
                      //     style: TextStyle(fontSize: 16),
                      //     textAlign: TextAlign.center,
                      //   ),
                      // ),
                      background: FadeInImage(
                          placeholder: AssetImage('assets/loading.gif'),
                          image: NetworkImage(movie.fullbackDropPath),
                          fit: BoxFit.cover),
                    )
                    //collapsedHeight: 100,
                    ),
                SliverPersistentHeader(
                  delegate: MySliverPersistentHeaderDelegate(
                    TabBar(
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      unselectedLabelStyle:
                          TextStyle(fontWeight: FontWeight.normal),
                      indicatorColor: Colors.white,
                      tabs: [
                        Tab(
                          text: 'Horario',
                        ),
                        Tab(
                          text: 'Sipnosis',
                        ),
                      ],
                    ),
                  ),
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(
              children: [
                // _PosterAndTitle(movie: movie),
                TimeScreen(movie: movie),
                SinopsisScreen(movie: movie)
              ],
            ),
          )),
    );
  }
}

class CastingCards extends StatelessWidget {
  final int movieId;

  const CastingCards({required this.movieId});

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);

    return FutureBuilder(
        future: moviesProvider.getMovieCast(movieId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Container(
              width: double.infinity,
              height: 180,
              child: CupertinoActivityIndicator(),
            );
          }

          final List<Cast> cast = snapshot.data!;

          return Container(
            width: double.infinity,
            height: 180,
            margin: EdgeInsets.only(bottom: 20),
            child: ListView.builder(
              itemCount: cast.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return _CastCard(actor: cast[index]);
              },
            ),
          );
        });
  }
}

class _CastCard extends StatelessWidget {
  final Cast actor;

  const _CastCard({Key? key, required this.actor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      width: 110,
      height: 100,
      child: Column(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                  placeholder: AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(actor.fullProfilePath),
                  height: 140,
                  width: 100,
                  fit: BoxFit.cover)),
          SizedBox(
            height: 5,
          ),
          Text(
            actor.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  final Movie movie;

  const _CustomAppBar({required this.movie});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(
        movie.title,
        style: TextStyle(fontSize: 16),
      ),
      backgroundColor: Colors.red,
      expandedHeight: 200,
      //floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        // titlePadding: EdgeInsets.all(0),
        // centerTitle: true,
        // title: Container(
        //   padding: EdgeInsets.only(bottom: 50, left: 10, right: 10),
        //   width: double.infinity,
        //   alignment: Alignment.bottomCenter,
        //   color: Colors.black12,
        //   child: Text(
        //     movie.title,
        //     style: TextStyle(fontSize: 16),
        //     textAlign: TextAlign.center,
        //   ),
        // ),
        background: FadeInImage(
            placeholder: AssetImage('assets/loading.gif'),
            image: NetworkImage(movie.fullbackDropPath),
            fit: BoxFit.cover),
      ),
      bottom: TabBar(tabs: [
        Tab(
          text: 'Horario',
          icon: Icon(Icons.calendar_today),
        ),
        Tab(text: 'Sipnosis', icon: Icon(Icons.description)),
      ]),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final Movie movie;

  const _PosterAndTitle({required this.movie});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(top: 20, right: 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Hero(
            tag: movie.heroId!,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(movie.fullPosterImg),
                  height: 150,
                )),
          ),
          SizedBox(
            width: 20,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: size.width - 190,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: textTheme.headline5,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Text(
                  movie.originalTitle,
                  style: textTheme.subtitle1,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Row(
                  children: [
                    Icon(Icons.star_outline, size: 15, color: Colors.grey),
                    SizedBox(width: 5),
                    Text(
                      movie.voteAverage.toString(),
                      style: textTheme.caption,
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  final Movie movie;

  const _Overview({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(
        movie.overview,
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}

class MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  MySliverPersistentHeaderDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Colors.red,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(MySliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
