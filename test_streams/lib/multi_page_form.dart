import 'package:flutter/material.dart';
import 'package:multi_page_form/multi_page_form.dart';

class Test extends StatefulWidget {
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiPageForm(
        totalPage: 3,
        pageList: <Widget>[page1(), page2(), page3()],
        onFormSubmitted: () {
          print("Form is submitted");
        },
        nextButtonStyle: Row(
          children: <Widget>[
            Text('Next'),
            SizedBox(
              width: 4,
            ),
            Icon(Icons.arrow_forward_ios)
          ],
        ),
        previousButtonStyle: Row(
          children: <Widget>[
            Icon(Icons.arrow_back_ios),
            SizedBox(
              width: 4,
            ),
            Text('Previous')
          ],
        ),
        submitButtonStyle: Row(
          children: <Widget>[
            Text('Submit'),
            SizedBox(width: 4,),
            Icon(Icons.play_arrow)
          ],
        ),
      ),
    );
  }

  Widget page1() {
    return Container(
      child: ListView(
        children: [
          Container(
            height: 120.0,
            width: 20.0,
            color: Colors.purple,
          ),
          Container(
            height: 120.0,
            width: 20.0,
            color: Colors.blue,
          )
        ],
      ),
    );
  }

  Widget page2() {
    return Container(
      child: ListView(
        children: [
          Container(
            height: 200.0,
            width: 200.0,
            color: Colors.yellow,
          )
        ],
      ),
    );
  }

  Widget page3() {
    return Container(
      child: ListView(
        children: [
          Container(
            height: 200.0,
            width: 200.0,
            color: Colors.green,
          )
        ],
      ),
    );
  }
}
