import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yiddishconnect/ui/home/match/matchPageProvider.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  final CardSwiperController _cardSwiperController = CardSwiperController();

  final Map<String, String> _imageUrlCache = {};

  Future<String> getFirebaseImageUrl(String path) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(path);
      final url = await ref.getDownloadURL();
      print("✅ Image URL fetched: $url");
      return url;
    } catch (e) {
      print("❌ Firebase Storage Error: $e");
      return "";
    }
  }

  Widget _buildImage(String url) {
    return AspectRatio(
      aspectRatio: 4 / 5,
      child: Image.network(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image, size: 100, color: Colors.red);
        },
      ),
    );
  }

  /// 🧠 Store like/dislike in Firestore
  Future<void> handleSwipeAction({
    required bool isLike,
    required String swipedUserId,
    required Map<String, dynamic> swipedUser,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final currentUserId = currentUser.uid;

    if (!isLike) {
      print("👎 Disliked ${swipedUser['name']}");
      return;
    }

    // Check if swiped user already liked current user
    final mutualMatch = await FirebaseFirestore.instance
        .collection('matches')
        .where('user1', isEqualTo: swipedUserId)
        .where('user2', isEqualTo: currentUserId)
        .where('status', isEqualTo: 0)
        .get();

    if (mutualMatch.docs.isNotEmpty) {
      // Update both match docs to status = 1
      await FirebaseFirestore.instance.collection('matches').add({
        'user1': currentUserId,
        'user2': swipedUserId,
        'status': 1,
        'matchedAt': Timestamp.now(),
      });
      print("🎉 It's a MATCH with ${swipedUser['name']}!");
    } else {
      // Record one-sided like
      await FirebaseFirestore.instance.collection('matches').add({
        'user1': currentUserId,
        'user2': swipedUserId,
        'status': 0,
        'matchedAt': Timestamp.now(),
      });
      print("👍 Liked ${swipedUser['name']}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MatchPageProvider>(
        builder: (context, matchProvider, child) {
          return Column(
            children: [
              const SizedBox(height: 40),
              Text("Max Distance: ${matchProvider.maxDistance}"),
              Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: matchProvider.getNearbyUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No matches found"));
                    }

                    return CardSwiper(
                      controller: _cardSwiperController,
                      cardsCount: snapshot.data!.length,
                      numberOfCardsDisplayed: snapshot.data!.length,
                      onSwipe: (previousIndex, currentIndex, direction) async {
                        final user = snapshot.data![previousIndex];
                        final isLike = direction == CardSwiperDirection.right;
                        await handleSwipeAction(
                          isLike: isLike,
                          swipedUserId: user['uid'],
                          swipedUser: user,
                        );
                        return true;
                      },
                      cardBuilder: (context, index, _, __) {
                        final user = snapshot.data![index];
                        String imagePath = "";

                        if (user['imageUrls'] is List &&
                            user['imageUrls'].isNotEmpty) {
                          imagePath = user['imageUrls'][0];
                        } else if (user['profilePhoto'] != null) {
                          imagePath = user['profilePhoto'];
                        }

                        return Center(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 5,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Column(
                                children: [
                                  // 🔹 IMAGE SECTION
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(16)),
                                      child: imagePath.isNotEmpty
                                          ? _imageUrlCache
                                          .containsKey(imagePath)
                                          ? _buildImage(
                                          _imageUrlCache[imagePath]!)
                                          : FutureBuilder<String>(
                                        future: getFirebaseImageUrl(
                                            imagePath),
                                        builder: (context, snap) {
                                          if (snap.connectionState ==
                                              ConnectionState
                                                  .waiting) {
                                            return const Center(
                                              child:
                                              CircularProgressIndicator(),
                                            );
                                          }
                                          if (!snap.hasData ||
                                              snap.data!.isEmpty) {
                                            return const Icon(
                                                Icons.broken_image,
                                                size: 100,
                                                color: Colors.red);
                                          }
                                          _imageUrlCache[imagePath] =
                                          snap.data!;
                                          return _buildImage(
                                              snap.data!);
                                        },
                                      )
                                          : const Icon(Icons.account_circle,
                                          size: 100),
                                    ),
                                  ),

                                  // 🔹 PROFILE INFO
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          user['name'] ?? "Unknown",
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Distance: ${user['distance']?.toStringAsFixed(1) ?? 'Unknown'} miles",
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
