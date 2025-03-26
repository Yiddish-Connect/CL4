
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
      return await ref.getDownloadURL();
    } catch (e) {
      print("❌ Error fetching image: $e");
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

  Future<void> handleSwipeAction({
    required bool isLike,
    required String swipedUserId,
    required Map<String, dynamic> swipedUser,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;
    final matchCollection = FirebaseFirestore.instance.collection('matches');
    final currentUserId = currentUser.uid;
    final status = isLike ? 0 : -1;

    final existing1 = await matchCollection
        .where('user1', isEqualTo: currentUserId)
        .where('user2', isEqualTo: swipedUserId)
        .get();
    final existing2 = await matchCollection
        .where('user1', isEqualTo: swipedUserId)
        .where('user2', isEqualTo: currentUserId)
        .get();

    int? existingStatus;
    if (existing1.docs.isNotEmpty) {
      existingStatus = existing1.docs.first['status'];
    }
    if (existing2.docs.isNotEmpty) {
      existingStatus = existing2.docs.first['status'];
    }

    if (existing1.docs.isNotEmpty || existing2.docs.isNotEmpty) {
      final doc = (existing1.docs + existing2.docs).first;
      if (isLike && existingStatus == 0 && existing2.docs.isNotEmpty) {
        await matchCollection.doc(doc.id).update({
          'status': 1,
          'matchedAt': Timestamp.now(),
        });
        print("🎉 MATCHED with ${swipedUser['name']}");
      } else {
        await matchCollection.doc(doc.id).update({
          'status': status,
          'matchedAt': Timestamp.now(),
        });
        print(isLike ? "👍 Updated like" : "👎 Updated dislike");
      }
      return;
    }

    await matchCollection.add({
      'user1': currentUserId,
      'user2': swipedUserId,
      'status': status,
      'matchedAt': Timestamp.now(),
    });
    print(isLike ? "👍 Liked ${swipedUser['name']}" : "👎 Disliked ${swipedUser['name']}");
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

                    final matchList = snapshot.data ?? [];
                    if (matchList.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Text(
                            "You have no more matches.\nTry adjusting your preferences.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      );
                    }

                    return CardSwiper(
                      controller: _cardSwiperController,
                      cardsCount: matchList.length,
                      numberOfCardsDisplayed: matchList.length,
                      onSwipe: (previousIndex, currentIndex, direction) async {
                        final user = matchList[previousIndex];
                        final isLike = direction == CardSwiperDirection.right;
                        await handleSwipeAction(
                          isLike: isLike,
                          swipedUserId: user['uid'],
                          swipedUser: user,
                        );
                        setState(() {});
                        return true;
                      },
                      cardBuilder: (context, index, _, __) {
                        final user = matchList[index];
                        String imagePath = "";
                        if (user['imageUrls'] is List && user['imageUrls'].isNotEmpty) {
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
                              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                      child: imagePath.isNotEmpty
                                          ? _imageUrlCache.containsKey(imagePath)
                                          ? _buildImage(_imageUrlCache[imagePath]!)
                                          : FutureBuilder<String>(
                                        future: getFirebaseImageUrl(imagePath),
                                        builder: (context, snap) {
                                          if (snap.connectionState == ConnectionState.waiting) {
                                            return const Center(child: CircularProgressIndicator());
                                          }
                                          if (!snap.hasData || snap.data!.isEmpty) {
                                            return const Icon(Icons.broken_image, size: 100, color: Colors.red);
                                          }
                                          _imageUrlCache[imagePath] = snap.data!;
                                          return _buildImage(snap.data!);
                                        },
                                      )
                                          : const Icon(Icons.account_circle, size: 100),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          user['name'] ?? "Unknown",
                                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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



