import "package:flutter/material.dart";

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  "images/home.jpg",
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3.20,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 35.0, left: 50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(45.0),

                        child: Image.asset(
                          "images/boy.png",
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 120, left: 10.0),
                  child: Column(
                    children: [
                      Text(
                        "Travelers",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Lato',
                          fontSize: 50.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Travel the world",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontFamily: 'Lato',
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 30.0,
                    right: 30.0,
                    top: MediaQuery.of(context).size.height / 3.5,
                  ),

                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      margin: EdgeInsets.only(left: 0.25, right: 0.25),
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 1.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search for places to visit",
                          suffixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40.0),
            Container(
              child: Column(
                children: [
                  Image.asset(
                    "images/boy.png",
                    height: 50.0,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
