import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yiddishconnect/ui/home/match/matchPageProvider.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  @override
  void initState() {
    print("MatchPage initState()... (This should only happen once)");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("MatchPage build()");
    return Scaffold(
      body: Consumer<MatchPageProvider>(
        builder: (context, matchProvider, child) {
          return Center(
            child: Column(
              children: [
                Text("Max Distance: ${matchProvider.maxDistance}"),
                StreamBuilder<List<Map<String, dynamic>>>(
                  stream: matchProvider.getNearbyUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text("No matches found");
                    }
                    return Column(
                      children: snapshot.data!.map((user) {
                        return ListTile(
                          title: Text(user['name'] ?? "Unknown"),
                          subtitle: Text("Distance: ${user['distance']?.toStringAsFixed(1)} miles"),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
