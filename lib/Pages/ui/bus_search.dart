import 'dart:async';
import 'dart:math';

import 'package:bus_by_u/Assistant/geoFireAssistant.dart';
import 'package:bus_by_u/Models/nearbyAvailableDrivers.dart';
import 'package:bus_by_u/ScheduleTimeTable/timeTable.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../globle.dart';
import '../../main.dart';
import '../../users.dart';
import '../EditProfile/EditProfile.dart';
import '../Registration/Log_In.dart';
import '../Support/support.dart';

class bus_search extends StatefulWidget {
  const bus_search({super.key});

  @override
  State<bus_search> createState() => _bus_searchState();
}

class _bus_searchState extends State<bus_search> {
  String? selectedValue;
  bool nearByAvailableDriversLoaded = false;
  Set<Marker> markersSet = {};
  List routesList = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapController? newGoogleMapController;
  Completer<GoogleMapController> _controller = Completer();
  String? selectedRoutesType;
  String? selectedShuttleType;
  final auth = FirebaseAuth.instance;
  String routeIndex = '00';
  TextEditingController nameCtrl = TextEditingController();

  BitmapDescriptor? nearByIcon;
  Position? currentPosition;
  var geoLocator = Geolocator();

  final List<String> items = [
    "Piran Ghaib(Boys & Girls)",
    "Mumtazabad(Boys & Girls)",
    "By Pass(Boys & Girls)",
    "Makhdom Rasheed(Boys & Girls)",
    "Bamd Bosan(Ailam Pur)(Boys & Girls)",
    "Chowk Shahidan(Boys & Girls)",
    "Basti Khudad Mill Muzafarabad",
    "Shah Ruk-ne-Alam(Boys & Girls)",
    "Seven Up Factory(Boys & Girls)",
    "Sher Shah(Boys & Girls)",
    "City Routes(Boys & Girls)",
    "Textile College",
    "Qasim Baila(Boys & Girls)",
    "Bilal Chowk(Boys & Girls)",
    "Wallayatabad(Boys & Girls)",
    "Masoom Shah Road(Boys & Girls)",
    "Darse Chawan(Boys & Girls)",
    "Adda Laar(Boys & Girls)",
    "IMs(Khuda Dad & By Pass)",
    "Kabir wala(Boys & Girls)",
  ];

  List<DropdownMenuItem<String>> _addDividersAfterItems(List<String> items) {
    List<DropdownMenuItem<String>> _menuItems = [];
    for (var item in items) {
      _menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
          //If it's last item, we will not add Divider after it.
          if (item != items.last)
            const DropdownMenuItem<String>(
              enabled: false,
              child: Divider(),
            ),
        ],
      );
    }
    return _menuItems;
  }

  List<double> _getCustomItemsHeights() {
    List<double> _itemsHeights = [];
    for (var i = 0; i < (items.length * 2) - 1; i++) {
      if (i.isEven) {
        _itemsHeights.add(40);
      }
      //Dividers indexes will be the odd indexes
      if (i.isOdd) {
        _itemsHeights.add(4);
      }
    }
    return _itemsHeights;
  }

  List<String> routeTypesList = [
    "Piran Ghaib(Boys & Girls)",
    "Mumtazabad(Boys & Girls)",
    "By Pass(Boys & Girls)",
    "Makhdom Rasheed(Boys & Girls)",
    "Bamd Bosan(Ailam Pur)(Boys & Girls)",
    "Chowk Shahidan(Boys & Girls)",
    "Basti Khudad Mill Muzafarabad",
    "Shah Ruk-ne-Alam(Boys & Girls)",
    "Seven Up Factory(Boys & Girls)",
    "Sher Shah(Boys & Girls)",
    "City Routes(Boys & Girls)",
    "Textile College",
    "Qasim Baila(Boys & Girls)",
    "Bilal Chowk(Boys & Girls)",
    "Wallayatabad(Boys & Girls)",
    "Masoom Shah Road(Boys & Girls)",
    "Darse Chawan(Boys & Girls)",
    "Adda Laar(Boys & Girls)",
    "IMs(Khuda Dad & By Pass)",
    "Kabir wala(Boys & Girls)",
  ];

  List<String> shuttleTypesList = [
    "Shuttle 1",
    "Shuttle 2",
  ];

  void locatePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);
    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    initGeoFireListner();
  }

  final CameraPosition _cameraPosition = const CameraPosition(
    target: LatLng(30.162750784907014, 71.52545420721886),
    zoom: 14.4746,
  );

  //function to get user data from firebase
  getUsersData() async {
    final snapshot = await usersRef.child(currentFirebaseUser!.uid).get();
    print(snapshot.value!);
    setState(() {
      currentUsersinfo = Users.fromSnapshot(snapshot);
    });
    debugPrint(currentUsersinfo!.name);
    print(currentUsersinfo!.profile);
  }

  String markersInforWindowRoute = 'Please Select First';
  @override
  void initState() {
    // TODO: implement initState
    getUsersData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    createIconMarker();
    return Scaffold(
        drawer: Drawer(
          child: drawerMethod(context),
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Select the bus"),
          leading: Builder(
            builder: (context) => IconButton(
              icon: new Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        body: Container(
          child: Column(
            children: [
              Container(
                //height: 100,
                color: Colors.grey.withOpacity(0.8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          // customButton: const Icon(
                          //   Icons.directions_bus,
                          //   size: 30,
                          //   color: Colors.white,
                          // ),
                          isExpanded: true,
                          items: _addDividersAfterItems(items),
                          value: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value as String;
                              if (items.indexOf(value) <= 9) {
                                routeIndex = '0${items.indexOf(value) + 1}';
                              } else {
                                routeIndex = '${items.indexOf(value) + 1}';
                              }
                              print(routeIndex);
                              print(routeIndex[0]);
                              print(routeIndex[1]);

                              markersInforWindowRoute = selectedValue!;
                              initGeoFireListner();
                            });
                          },
                          buttonStyleData:
                              const ButtonStyleData(height: 20, width: 250),
                          dropdownStyleData: DropdownStyleData(
                              maxHeight: 500,
                              width: MediaQuery.of(context).size.width * 0.5),
                          menuItemStyleData: MenuItemStyleData(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            customHeights: _getCustomItemsHeights(),
                          ),
                        ),
                      ),
                    ),
                    DropdownButton(
                      iconEnabledColor: Colors.white,
                      iconSize: 26,
                      dropdownColor: Colors.white,
                      // hint: const Text(
                      //   "Choose your Shuttle type",
                      //   style: TextStyle(
                      //     fontSize: 15,
                      //     color: Colors.black,
                      //   ),
                      // ),
                      value: selectedShuttleType,

                      onChanged: (newValue) {
                        setState(() {
                          selectedShuttleType = newValue.toString();
                          markersInforWindowRoute = selectedShuttleType!;
                          routeIndex =
                              '${shuttleTypesList.indexOf(newValue!) + 21}';
                          print(routeIndex);
                          initGeoFireListner();
                        });
                      },
                      items: shuttleTypesList.map((shuttle) {
                        return DropdownMenuItem(
                          child: Text(
                            shuttle,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          value: shuttle,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Stack(children: [
                Container(
                  height: 720,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    myLocationButtonEnabled: true,
                    initialCameraPosition: _cameraPosition,
                    myLocationEnabled: true,
                    markers: markersSet,
                    // zoomControlsEnabled: true,
                    // zoomGesturesEnabled: true,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                      newGoogleMapController = controller;
                      locatePosition();
                    },
                  ),
                ),
              ])
            ],
          ),
        ));
  }

  Padding drawerMethod(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.15,
              ),
              Center(
                child: Container(
                  height: 124,
                  width: 124,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent),
                  child: currentUsersinfo != null
                      ? Image.network(
                          currentUsersinfo!.profile!,
                          fit: BoxFit.fill,
                        )
                      : Center(
                          child: Container(
                            height: 150,
                            width: 170,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                              image: AssetImage(
                                "images/bbu.png",
                              ),
                              fit: BoxFit.cover,
                            )),
                          ),
                        ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.05,
              ),
              Text(
                currentUsersinfo?.name ?? '',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.1,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfile()),
                  );
                },
                child: Row(
                  children: const [
                    Icon(Icons.edit),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      'Edit Profile',
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
              Divider(),
              Row(
                children: const [
                  Icon(Icons.email_outlined),
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    'Invite Friend',
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
              Divider(),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TimeTable()));
                },
                child: Row(
                  children: const [
                    Icon(Icons.timer),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      'Schedule Time Table',
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
              Divider(),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SupportPage()));
                },
                child: Row(
                  children: const [
                    Icon(Icons.support),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      'Support',
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
              Divider(),
              GestureDetector(
                onTap: () {
                  auth.signOut().then(
                    (value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LogIn(),
                          ));
                    },
                  ).onError(
                    (error, stackTrace) {
                      Fluttertoast.showToast(
                        msg: error.toString(),
                      );
                    },
                  );
                },
                child: Row(
                  children: const [
                    Icon(Icons.logout),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      'Logout',
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
              Divider(),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    launchUrl(
                        Uri.parse('https://www.facebook.com/bzupakistan'));
                  },
                  child: const Icon(
                    Icons.facebook,
                    color: Colors.blueAccent,
                    size: 40,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    launchUrl(Uri.parse('https://www.bzu.edu.pk/'));
                  },
                  child: const Icon(
                    Icons.wordpress_rounded,
                    color: Colors.black,
                    size: 40,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void createIconMarker() {
    if (nearByIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: Size(1, 1));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/bus.png")
          .then((value) {
        nearByIcon = value;
      });
    }
  }

  void initGeoFireListner() {
    Geofire.initialize("availableDrivers");
    //start
    Geofire.queryAtLocation(
            currentPosition!.latitude, currentPosition!.longitude, 10)
        ?.listen((map) {
      print(map);
      if (map != null) {
        var callBack = map['callBack'];
        String? keyExtract = map['key'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {
          case Geofire.onKeyEntered:
            print('keyExtract');
            print(keyExtract);
            print(keyExtract![0]);
            print(keyExtract[1]);
            print('ROute Index');
            print(routeIndex[0]);
            print(routeIndex[1]);
            markersSet = {};
            markersSet.clear();
            markersSet.remove(map['key']);
            setState(() {
              markersSet = {};
              markersSet.clear();
              markersSet.remove(map['key']);
              print('Markers set  in else');
              print(markersSet);
            });
            if (keyExtract[0].contains(routeIndex[0]) &&
                keyExtract[1].contains(routeIndex[1])) {
              print('Markers set');
              print(markersSet);
              NearByAvailableDrivers nearByAvailableDrivers =
                  NearByAvailableDrivers();
              nearByAvailableDrivers.key = map['key'];
              print('Key value::::::::::::');
              print(nearByAvailableDrivers.key);
              print(map['key']);
              nearByAvailableDrivers.latitude = map['latitude'];
              nearByAvailableDrivers.longitude = map['longitude'];
              GeoFireAssistant.nearbyAvailableDriversList
                  .add(nearByAvailableDrivers);
            }
            // else if (keyExtract[0] != routeIndex[0] &&
            //     keyExtract[1] != routeIndex[1]) {
            //
            // }

            if (nearByAvailableDriversLoaded == true) {
              updateAvailableDriversOnMap();
            }
            break;

          case Geofire.onKeyExited:
            GeoFireAssistant.removeDriverFromList(map['key']);
            updateAvailableDriversOnMap();
            break;

          case Geofire.onKeyMoved:
            NearByAvailableDrivers nearByAvailableDrivers =
                NearByAvailableDrivers();
            nearByAvailableDrivers.key = map['key'];
            nearByAvailableDrivers.latitude = map['latitude'];
            nearByAvailableDrivers.longitude = map['longitude'];
            GeoFireAssistant.updateDriverNearbyLocation(nearByAvailableDrivers);
            updateAvailableDriversOnMap();
            break;

          case Geofire.onGeoQueryReady:
            updateAvailableDriversOnMap();
            print(map['result']);

            break;
        }
      }

      setState(() {});
    });
    //end
  }

  void updateAvailableDriversOnMap() {
    setState(() {
      markersSet.clear();
    });

    Set<Marker> tMarkers = Set<Marker>();
    for (NearByAvailableDrivers drivers
        in GeoFireAssistant.nearbyAvailableDriversList) {
      LatLng driverAvailablePosition =
          LatLng(drivers.latitude!, drivers.longitude!);
      Marker marker = Marker(
        markerId: MarkerId('drivers${drivers.key}'),
        position: driverAvailablePosition,
        icon: nearByIcon!,
        rotation: createRandomNumber(270),
        // infoWindow: InfoWindow(
        //   title: '${markersInforWindowRoute}',
        // ),
      );
      tMarkers.add(marker);
    }
    setState(() {
      markersSet = tMarkers;
    });
  }

  static double createRandomNumber(int num) {
    var random = Random();
    int radNumber = random.nextInt(num);
    return radNumber.toDouble();
  }
}

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({
    required this.text,
    required this.icon,
  });
}

class MenuItems {
  static const List<MenuItem> firstItems = [home, share, settings];
  static const List<MenuItem> secondItems = [logout];

  static const home = MenuItem(text: 'Home', icon: Icons.home);
  static const share = MenuItem(text: 'Share', icon: Icons.share);
  static const settings = MenuItem(text: 'Settings', icon: Icons.settings);
  static const logout = MenuItem(text: 'Log Out', icon: Icons.logout);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.white, size: 22),
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  static onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.home:
        //Do something
        break;
      case MenuItems.settings:
        //Do something
        break;
      case MenuItems.share:
        //Do something
        break;
      case MenuItems.logout:
        //Do something
        break;
    }
  }
}
