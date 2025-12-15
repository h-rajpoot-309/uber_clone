import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
// import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

FirebaseStorage storage = FirebaseStorage.instance;
final picker = ImagePicker();
DatabaseReference realTimeDatabaseRef = FirebaseDatabase.instance.ref();

// final FirebaseDatabase database = FirebaseDatabase.instanceFor(
//   app: Firebase.app(),
//   databaseURL: "https://uber-e4a97-default-rtdb.firebaseio.com",
// );
// // Use this everywhere
// DatabaseReference realTimeDatabaseRef = database.ref();

FirebaseAuth auth = FirebaseAuth.instance;
PersistentTabController partnerBottomNavbarController = PersistentTabController(
  initialIndex: 0,
);
AudioPlayer audioPlayer = AudioPlayer();
