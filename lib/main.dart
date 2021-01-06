import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'amplifyconfiguration.dart';
import './signup.dart';
import './login.dart';
import './auth_service.dart';
import './instructor_bio.dart';

var listSample2 = [
  {
    "id": 1,
    "portrait":
        "https://s4.thcdn.com/widgets/125-us/35/480x480_Karina-031735.jpg",
    "bio":
        "Abigail has been teaching Yoga for WSU, at both Ogden and Davis Campuses, since 2005.  She has completed 200 Hour Registered Yoga Teacher (RYT), 500 Hour E-RYT, and is currently 1,000 Hour RYT certified, she’s also a registered Yoga Alliance Educator for their Teacher Training Program.  When you attend her classes she wants you to feel strong, capable, and successful. ",
    "availability": ["111", "222", "333", "444"],
    "classPhoto":
        "https://format-com-cld-res.cloudinary.com/image/private/s--rzRFdYgK--/c_crop,h_2560,w_3840,x_0,y_0/c_fill,g_center,h_760,w_1140/fl_keep_iptc.progressive,q_95/v1/78e7842f08f5eb5d3165c379a9e62c36/Luna_Alignment_Yoga_-_July_2017_TTC_44.jpg",
    "instructor": "Abigail Miller",
    "genre": "Yoga",
    "price": 30,
  },
  {
    "id": 2,
    "portrait":
        "https://image.freepik.com/free-photo/side-view-of-fit-man-posing-while-wearing-tank-top-with-crossed-arms_23-2148700611.jpg",
    "bio":
        "Bill is the Fitness Coordinator for Campus Recreation at Weber State University. He is a PTA Global Certified Personal Trainer with advanced credentials in Exercise.",
    "availability": [],
    "classPhoto":
        "https://media.gettyimages.com/photos/young-fitness-trainer-portrait-in-the-gym-picture-id1136449220",
    "instructor": "Bill Anderson",
    "genre": "Weight Training",
    "price": 40,
  },
  {
    "id": 3,
    "portrait":
        "https://sp.womenshealth-jp.com/fit-night-out/resources/img/common/trainer_top_06.jpg",
    "bio":
        "Your Expert in Fight Sport Fitness and Practical Self Defense! Come through and train with me!!!",
    "availability": [],
    "classPhoto":
        "https://us.123rf.com/450wm/rmarmion/rmarmion1508/rmarmion150800008/43679547-%E3%82%AD%E3%83%83%E3%82%AF-%E3%83%9C%E3%82%AF%E3%82%B7%E3%83%B3%E3%82%B0%E3%81%AE%E3%83%88%E3%83%AC%E3%83%BC%E3%83%8B%E3%83%B3%E3%82%B0%E3%82%92%E3%81%97%E3%81%A6%E3%81%84%E3%82%8B%E4%BA%BA%E3%80%85-%E3%81%AE%E3%82%B0%E3%83%AB%E3%83%BC%E3%83%97.jpg?ver=6",
    "instructor": "Chris Morgan",
    "genre": "Kick Boxing",
    "price": 55,
  },
  {
    "id": 4,
    "portrait":
        "https://sp.womenshealth-jp.com/fit-night-out/resources/img/common/trainer_top_03.jpg",
    "bio":
        "a newly certified Schwinn Stretch Instructor, who is anxious to get her pedals moving in her classes.  From surfing to camping, Abbey enjoys all that adventure has to offer.  Along with being passionate about fitness and health, she is majoring in Radiologic Sciences at Weber State.  She’s excited to help you on your fitness journey, so saddle up and enjoy the rid",
    "availability": [],
    "classPhoto":
        "https://www.mtgec.jp/wellness/sixpad/sp/products/common/img/stretchring/img_stretchring03.jpg",
    "instructor": "Diana Bell",
    "genre": "Stretch",
    "price": 38,
  },
  {
    "id": 5,
    "portrait":
        "https://image.freepik.com/free-photo/side-view-of-fit-man-posing-while-wearing-tank-top-with-crossed-arms_23-2148700611.jpg",
    "bio":
        "As a physiologist and physician, I believe in integrating the scientific aspects of training with the joy and appreciation for the sport I’ve gained over thirty years of running and racing on trails, roads, and track.  My goal is to help build a varied, sensible training plan that fits into your busy lifestyle, and will help you reach the finish line happy, healthy, and enthusiastic for whatever challenges lie ahead.",
    "availability": [],
    "classPhoto":
        "https://www.sciencemag.org/sites/default/files/styles/article_main_large/public/1036780592-1280x720.jpg?itok=QykjHcAC",
    "instructor": "Evans Clark",
    "genre": "Running",
    "price": 35,
  },
  {
    "id": 6,
    "portrait":
        "https://image.freepik.com/free-photo/side-view-of-fit-man-posing-while-wearing-tank-top-with-crossed-arms_23-2148700611.jpg",
    "bio":
        "Perform better, look better and feel better. Let me start by saying, you have come to the right place! You have taken the first step to change and we can help you to achieve this, whether it’s to: Lose fat,Build muscle,Improve your fitness and performance,Improve your health. By providing a face to face consultation at your home or in my London Clinic or by providing an engaging, interactive group workshops. The Diet Consultant can help.",
    "availability": [],
    "classPhoto":
        "https://www.gettimely.com/wp-content/uploads/2016/11/fitness-nutrition-advice-1400x800-c-default.jpg",
    "instructor": "Fred Adams",
    "genre": "Nutrition advisory",
    "price": 40,
  },
  {
    "id": 7,
    "portrait":
        "https://www.zumba.com/img/blt/about/love-testimonial-1-xsmall.jpg",
    "bio":
        "After the birth of her 2nd child, Nicole was looking for a way to get healthy and fit and started doing Zumba workouts at home. She then started up an exercise class with a group of friends, which lead her to find a passion for Zumba and she got certified. Nicole has been teaching for a little over 2 years and has loved every second of it. She truly believes in helping all people feel welcome to work out and have fun in a judgment-free environment. When she's not teaching Zumba, she is filling orders for her Etsy shop, reading books, traveling, and spending time with her husband and kids.",
    "availability": [],
    "classPhoto":
        "https://img.freepik.com/free-photo/women-in-sportswear-at-zumba-dance-class_73762-500.jpg?size=626&ext=jpg",
    "instructor": "Giselle Garcia",
    "genre": "Zumba",
    "price": 50,
  },
  {
    "id": 8,
    "portrait":
        "https://image.freepik.com/free-photo/side-view-of-fit-man-posing-while-wearing-tank-top-with-crossed-arms_23-2148700611.jpg",
    "bio":
        "Hanna is Fitness Instructor for over 25 years, “Teaching is not a job for me, it’s a fun way to get to work out and interact with a great group of people, I love my students and the positive energy they bring to class”.  She’s taught a variety of classes, for a broad range of participants, to include teaching in Okinawa, Japan.  She teaches Boot Camp, Circuit, Cycle, Step, and Strength & Cardio.  She believes there is never a bad day at the gym, working out is not just looking good on the outside, it's feeling great on the inside.  Don’t miss out on opportunities to be the best you, ‘It is not what you are that holds you back, it is what you think you are not’…",
    "availability": [],
    "classPhoto":
        "https://www.exercise.co.uk/wp/wp-content/uploads/2019/02/Can-Aerobic-Exercise-be-Bad-for-Your-Joints-Main.jpg",
    "instructor": "Hanna Taylor",
    "genre": "Aerobics",
    "price": 40,
  },
];

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.purple,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'skillTrain'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

//listView Code area

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      drawer: Drawer(
          child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Text('Menu'),
            decoration: BoxDecoration(
              color: Colors.orange[50],
            ),
          ),
          ListTile(
            title: Text('Booking status'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: Text('Sign up'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => _MyApp(),
                ),
              )
            },
          ),
          ListTile(
            title: Text('Log out'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
        ],
      ) // Populate the Drawer in the next step.
          ),
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Card(
              child: GestureDetector(
                  //画面遷移
                  onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => instructorBio(index: index),
                          ),
                        )
                      },
                  child: Column(
                    children: <Widget>[
                      Image.network(listSample2[index]["classPhoto"]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    listSample2[index]["instructor"],
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    listSample2[index]["genre"],
                                    textAlign: TextAlign.left,
                                  ),
                                ]),
                            new Spacer(),
                            Text(listSample2[index]["price"].toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35,
                                )),
                            Text("USD /h ",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 20,
                                )),
                          ]),
                    ],
                  )));
        },
        itemCount: listSample2.length,
      ),
    );
  }
}

class _MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<_MyApp> {
  bool _amplifyConfigured = false;
  final _authService = AuthService();
  // Instantiate Amplify
  Amplify amplifyInstance = Amplify();

  @override
  void initState() {
    super.initState();
    _configureAmplify();
    _authService.showLogin();
  }

  void _configureAmplify() async {
    if (!mounted) return;

    // Add Pinpoint and Cognito Plugins
    AmplifyAnalyticsPinpoint analyticsPlugin = AmplifyAnalyticsPinpoint();
    AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
    amplifyInstance.addPlugin(authPlugins: [authPlugin]);
    amplifyInstance.addPlugin(analyticsPlugins: [analyticsPlugin]);

    // Once Plugins are added, configure Amplify
    await amplifyInstance.configure(amplifyconfig);
    try {
      setState(() {
        _amplifyConfigured = true;
      });
    } catch (e) {
      print(e);
    }
  }

  void _recordEvent() async {
    AnalyticsEvent event = AnalyticsEvent("test");
    event.properties.addBoolProperty("boolKey", true);
    event.properties.addDoubleProperty("doubleKey", 10.0);
    event.properties.addIntProperty("intKey", 10);
    event.properties.addStringProperty("stringKey", "stringValue");
    Amplify.Analytics.recordEvent(event: event);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "skillTrain",
        theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
        home: StreamBuilder<AuthState>(
            stream: _authService.authStateController.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Navigator(
                  pages: [
                    if (snapshot.data.authFlowStatus == AuthFlowStatus.login)
                      MaterialPage(
                          child: LoginPage(
                              shouldShowSignUp: _authService.showSignUp)),
                    if (snapshot.data.authFlowStatus == AuthFlowStatus.signUp)
                      MaterialPage(child: SignUpPage())
                  ],
                  onPopPage: (route, result) => route.didPop(result),
                );
              } else {
                return Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
