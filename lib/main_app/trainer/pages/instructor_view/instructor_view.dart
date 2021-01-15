import 'package:flutter/material.dart';
import '../../../../utils/sliders.dart';
import 'pages/instructor_bio_update.dart';
import 'pages/instructor_upcoming_schedule.dart';
import 'pages/instructor_register_course.dart';

class Instructor extends StatelessWidget {
  final int index;
  Instructor({this.index});

  @override
  Widget build(BuildContext context) {
//JSON file download and decode

    return Scaffold(
      appBar: AppBar(
        title: Text("instructor page"),
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Colors.pink[300],
                  Colors.purple[500],
                  Colors.purple[700],
                ],
              ),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                new Spacer(),
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    SlideRightRoute(page: InstructorUpcomingSchedule()),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(
                      10.0,
                    ),
                    width: 400,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54, width: 3),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white70,
                    ),
                    child: Column(
                      children: <Widget>[
                        Image.asset('assets/images/confirmation.png',
                            height: 150, fit: BoxFit.fill),
                        Text(
                          "Upcoming schedule",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.black54),
                        )
                      ],
                    ),
                  ),
                ),
                new Spacer(),
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    SlideRightRoute(page: InstructorRegisterCourse()),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(
                      10.0,
                    ),
                    width: 400,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54, width: 3),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white70,
                    ),
                    child: Column(
                      children: <Widget>[
                        Image.asset('assets/images/classRegister.png',
                            height: 150, fit: BoxFit.fill),
                        Text(
                          "Course registration",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.black54),
                        )
                      ],
                    ),
                  ),
                ),
                new Spacer(),
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    SlideRightRoute(page: InstructorBioUpdate()),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(
                      10.0,
                    ),
                    width: 400,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54, width: 3),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white70,
                    ),
                    child: Column(
                      children: <Widget>[
                        Image.asset('assets/images/bio.png',
                            height: 150, fit: BoxFit.fill),
                        Text(
                          "Update bios",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.black54),
                        )
                      ],
                    ),
                  ),
                ),
                new Spacer(),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
