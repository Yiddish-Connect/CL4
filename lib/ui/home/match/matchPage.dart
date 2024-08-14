import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yiddishconnect/ui/home/match/matchPageProvider.dart';

// The "Match" tab under the home-screen
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
    return Container(
      color: Colors.teal,
      child: Center(
        child: Column(
          children: [
            Text("Practice Option: ${context.watch<MatchPageProvider>().practiceOptionsSelection.toString()}"),
            Text("Yiddish Proficiency: ${context.watch<MatchPageProvider>().yiddishProficiencySelection.toString()}"),
            Text("maxDistance: ${context.watch<MatchPageProvider>().maxDistance.toString()}"),
            Text("minAge: ${context.watch<MatchPageProvider>().minAge.toString()}"),
            Text("maxAge: ${context.watch<MatchPageProvider>().maxAge.toString()}"),
          ],
        ),
      ),
    );
  }
}
