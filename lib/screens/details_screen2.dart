import 'dart:io';

import 'package:flutter/material.dart';
import 'package:peliculas/screens/tabs/sinopsis_screen.dart';
import 'package:peliculas/screens/tabs/time_screen.dart';

import '../models/models.dart';

class DetailsScreen2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DetailsScreen2();
}

class _DetailsScreen2 extends State<DetailsScreen2> {
  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;

    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverSafeArea(
                  top: false,
                  bottom: Platform.isIOS ? false : true,
                  sliver: SliverAppBar(
                    title: Text(
                      movie.title,
                      style: TextStyle(fontSize: 18),
                    ),
                    backgroundColor: Colors.red,
                    expandedHeight: 220,
                    floating: true,
                    pinned: true,
                    snap: true,
                    forceElevated: innerBoxIsScrolled,
                    flexibleSpace: FlexibleSpaceBar(
                      background: FadeInImage(
                          placeholder: AssetImage('assets/loading.gif'),
                          image: NetworkImage(movie.fullbackDropPath),
                          fit: BoxFit.cover),
                    ),
                    bottom: PreferredSize(
                        preferredSize: _tabBar.preferredSize,
                        child: ColoredBox(
                          color: Colors.black26,
                          child: _tabBar,
                        )),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              Builder(
                builder: (BuildContext context) {
                  return NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      return true;
                    },
                    child: CustomScrollView(
                      key: PageStorageKey<String>('Horarios'),
                      slivers: <Widget>[
                        SliverOverlapInjector(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context),
                        ),
                        SliverList(
                          delegate: SliverChildListDelegate([
                            TimeScreen(movie: movie),
                          ]),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Builder(
                builder: (BuildContext context) {
                  return NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      return true;
                    },
                    child: CustomScrollView(
                      key: PageStorageKey<String>('Sinopsis'),
                      slivers: <Widget>[
                        SliverOverlapInjector(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context),
                        ),
                        SliverList(
                          delegate: SliverChildListDelegate(
                              [SinopsisScreen(movie: movie)]),
                        ),
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

TabBar get _tabBar => TabBar(
      labelStyle: TextStyle(fontWeight: FontWeight.bold),
      indicatorWeight: 5,
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
      indicatorColor: Colors.red,
      tabs: [
        Tab(
          text: 'Horarios',
        ),
        Tab(text: 'Sinopsis'),
      ],
    );
