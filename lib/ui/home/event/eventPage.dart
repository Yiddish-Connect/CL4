import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yiddishconnect/models/yiddishlandEvent.dart';
import 'package:yiddishconnect/services/firestore.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key}); // ✅ Fixed: const constructor

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  late Future<QuerySnapshot> futureEvents;
  final SearchController searchController = SearchController();
  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController = ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener = ScrollOffsetListener.create();

  @override
  void initState() {
    super.initState();
    debugPrint("🎯 EventPage initState()...");

    futureEvents = FirestoreService().yiddishlandEvents.get().then((snapshot) {
      debugPrint("✅ Successfully fetched ${snapshot.size} yiddishland events!");
      return snapshot;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: futureEvents,
      builder: (context, snapshot) {
        return NestedScrollView(
          headerSliverBuilder: (context, innerBoxScrolled) => [
            SliverAppBar(
              pinned: false,
              floating: true,
              snap: true,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Stack(
                  children: [
                    Center(child: Image.asset("assets/yiddishland.png")),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SearchAnchor(
                          searchController: searchController,
                          builder: (context, controller) => IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: controller.openView,
                          ),
                          suggestionsBuilder: (context, controller) {
                            if (!snapshot.hasData) return const [];

                            final searchText = searchController.text.toLowerCase();

                            return snapshot.data!.docs
                                .asMap()
                                .entries
                                .where((entry) {
                              final docData = entry.value.data() as Map<String, dynamic>;
                              final event = YiddishlandEvent.fromMap(docData, entry.value.id);
                              return event.title.toLowerCase().contains(searchText);
                            })
                                .map((entry) {
                              final docData = entry.value.data() as Map<String, dynamic>;
                              final event = YiddishlandEvent.fromMap(docData, entry.value.id);
                              return ListTile(
                                title: Text(event.title),
                                onTap: () {
                                  controller.closeView(event.title);
                                  itemScrollController.scrollTo(
                                    index: entry.key,
                                    duration: const Duration(milliseconds: 500),
                                  );
                                },
                              );
                            })
                                .toList();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              backgroundColor: Colors.blueGrey,
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 20,
                child: Center(
                  child: searchController.text.isEmpty
                      ? const Text('No item selected')
                      : Text('Selected: ${searchController.text}'),
                ),
              ),
            ),
          ],
          body: Builder(
            builder: (context) {
              if (snapshot.hasError) {
                return Center(child: Text('Something went wrong: ${snapshot.error}'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SizedBox(height: 50, width: 50, child: CircularProgressIndicator()),
                );
              }

              final docs = snapshot.data?.docs ?? [];

              return AnimationLimiter(
                child: ScrollablePositionedList.builder(
                  itemCount: docs.length,
                  itemScrollController: itemScrollController,
                  scrollOffsetController: scrollOffsetController,
                  itemPositionsListener: itemPositionsListener,
                  scrollOffsetListener: scrollOffsetListener,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final event = YiddishlandEvent.fromMap(data, doc.id);

                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 1000),
                      child: SlideAnimation(
                        verticalOffset: 150.0,
                        child: FadeInAnimation(child: _createEventCard(event)),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _createEventCard(YiddishlandEvent event) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: event.imageSrc.isNotEmpty
            ? Image.network(
          event.imageSrc,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        )
            : null,
        title: Text(
          event.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8.0),
            Text(event.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8.0),
            if (event.src.isNotEmpty)
              GestureDetector(
                onTap: () async {
                  final url = Uri.parse(event.src);
                  if (await canLaunchUrl(url)) {
                    launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
                child: Text(
                  event.src,
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
