import 'package:flutter/material.dart';
import './index.dart';

// class hoge extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Reserved Sessions List'),
//       ),
//       body: ListView.builder(
//         // need to be decided based on users's reserved sessions number
//         itemCount: 1,
//         itemBuilder: (context, index) {
//           return Container(
//               height: 100,
//               width: 220,
//               child: Card(
//                   child: ListTile(
//                       leading: Image.network(
//                           'https://format-com-cld-res.cloudinary.com/image/private/s--rzRFdYgK--/c_crop,h_2560,w_3840,x_0,y_0/c_fill,g_center,h_760,w_1140/fl_keep_iptc.progressive,q_95/v1/78e7842f08f5eb5d3165c379a9e62c36/Luna_Alignment_Yoga_-_July_2017_TTC_44.jpg'),
//                       title: Text('Sample Session'),
//                       subtitle: Text('Sample time 9:00-9:30'),
//                       trailing: Icon(Icons.video_call_rounded))));
//         },
//       ),
//     );
//   }
// }

class sessionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: IndexPage(),
    );
  }
}
