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
            sectionTitle(title: "Here are your Results!"),
            Expanded(
              child: FutureBuilder(
                  future: filteredTrainers,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.only(
                                left: 50, right: 50, top: 25, bottom: 25),
                            child: Card(
                              child: InkWell(
                                  splashColor: Colors.purple,
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
                                      child: Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                            child: Image.network(
                                                snapshot.data[index]
                                                    ["profilePhoto"],
                                                height: 150,
                                                width: 150,
                                                fit: BoxFit.fill),
                                          ),
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    snapshot.data[index]
                                                        ["username"],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(Icons.star,
                                                        color:
                                                            Colors.yellow[700],
                                                        size: 7),
                                                    Icon(Icons.star,
                                                        color:
                                                            Colors.yellow[700],
                                                        size: 7),
                                                    Icon(Icons.star,
                                                        color:
                                                            Colors.yellow[700],
                                                        size: 7),
                                                    Icon(Icons.star,
                                                        color: Colors.black,
                                                        size: 7),
                                                    Icon(Icons.star,
                                                        color: Colors.black,
                                                        size: 7),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(snapshot.data[index]
                                                  ["genre"]),
                                              Text(snapshot.data[index]["price"]
                                                      .toString() +
                                                  'p/s')
                                            ],
                                          )
                                        ],
                                      ))),
                            ),
                          );
                        },
                        itemCount: snapshot.data.length,
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    // By default, show a loading spinner.
                    return Container(
                        height: MediaQuery.of(context).size.height - 87,
                        decoration:
                            new BoxDecoration(color: Colors.deepPurple[100]),
                        child: Center(child: CircularProgressIndicator()));
                  }),
            ),
          ],
        ));
  }
}
