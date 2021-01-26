import 'package:flutter/material.dart';
import 'package:skilltrain/utils/sliders.dart';
import '../../common/fetchTrainers.dart';
import '../../common/headings.dart';
import 'instructor_bio.dart';

class TrainerFilter extends StatefulWidget {
  final String genreFilter;
  TrainerFilter({Key key, this.genreFilter}) : super(key: key);
  @override
  _TrainerFilterState createState() => _TrainerFilterState();
}

class _TrainerFilterState extends State<TrainerFilter> {
  Future filteredTrainers;

  @override
  void initState() {
    super.initState();
    filteredTrainers = fetchFilteredTrainers(widget.genreFilter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.purple,
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Color(0xFFFFFFFF),
          title: Image.asset(
            'assets/icon/icon.png',
            height: 36.0,
            width: 36.0,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                  future: filteredTrainers,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data.length > 0) {
                      return ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          List<Widget> stars = [];

                          for (var i = 0;
                              i < snapshot.data[index]["avgRating"];
                              i++) {
                            stars.add(Icon(Icons.star,
                                color: Colors.cyanAccent, size: 12));
                          }
                          return Container(
                            margin: EdgeInsets.only(
                                left: 50, right: 50, top: 0, bottom: 0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: InkWell(
                                  splashColor: Colors.cyanAccent,
                                  onTap: () => {
                                        Navigator.push(
                                          context,
                                          SlideRightRoute(
                                              page: InstructorBio(
                                                  data: snapshot.data[index],
                                                  index: index)),
                                        )
                                      },
                                  child: Container(
                                      padding: EdgeInsets.all(0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.network(
                                                  snapshot.data[index]
                                                      ["profilePhoto"],
                                                  height: 150,
                                                  width: 150,
                                                  fit: BoxFit.fill),
                                            ),
                                            Container(
                                              height: 150,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    snapshot.data[index]
                                                        ["username"],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15),
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: stars,
                                                  ),
                                                  Text(snapshot.data[index]
                                                      ["genre"]),
                                                  Text(
                                                      "¥" +
                                                          snapshot.data[index]
                                                                  ["price"]
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ))),
                            ),
                          );
                        },
                        itemCount: snapshot.data.length,
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    } else if (snapshot.hasData && snapshot.data.length == 0) {
                      return Center(
                          child: Text("No results were found",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)));
                    }
                    return Container(
                        height: MediaQuery.of(context).size.height,
                        decoration: new BoxDecoration(color: Colors.white),
                        child: Center(child: CircularProgressIndicator()));
                    // By default, show a loading spinner.
                  }),
            ),
          ],
        ));
  }
}
