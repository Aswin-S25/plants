import 'package:flutter/material.dart';
import 'package:plant/constants.dart';
import 'package:plant/models/plants.dart';
import 'package:plant/ui/screens/detail_page.dart';
import 'package:page_transition/page_transition.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    int selectedIndex = 0;
    Size size = MediaQuery.of(context).size;
    String searchQuery = '';

    List<Plant> plantList = Plant.plantList;

    //Plants category
    // List<String> plantTypes = [
    //   'Recommended',
    //   'Indoor',
    //   'Outdoor',
    //   'Garden',
    //   'Supplement',
    // ];

    //Toggle Favorite button
    bool toggleIsFavorated(bool isFavorited) {
      return !isFavorited;
    }

    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  width: size.width * .9,
                  decoration: BoxDecoration(
                    color: Constants.primaryColor.withOpacity(.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.black54.withOpacity(.6),
                      ),
                      const Expanded(
                          child: TextField(
                        showCursor: false,
                        decoration: InputDecoration(
                          hintText: 'Search Plant',
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      )),
                      Icon(
                        Icons.mic,
                        color: Colors.black54.withOpacity(.6),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          
          Container(
            padding: const EdgeInsets.only(left: 16, bottom: 20, top: 20),
            child: const Text(
              'New Plants',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: size.height * .7,
              child: const Addplant()),
        ],
      ),
    ));
  }
}




// ListView.builder(
//                 itemCount: plantList.length,
//                 scrollDirection: Axis.vertical,
//                 physics: const BouncingScrollPhysics(),
//                 itemBuilder: (BuildContext context, int index) {
//                   return GestureDetector(
//                       onTap: (){
//                         Navigator.push(context, PageTransition(child: DetailPage(plantId: plantList[index].plantId), type: PageTransitionType.bottomToTop));
//                       },
//                       child: PlantWidget(index: index, plantList: plantList));
//                 }),




