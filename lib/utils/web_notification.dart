import 'package:flutter/material.dart';

//https://www.youtube.com/watch?v=fhkaDua0rhE

class TheWebNotification extends StatelessWidget {
  final String messageTitle;
  final String messageDis;
  TheWebNotification(
      {super.key, required this.messageTitle, required this.messageDis});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment:
            Alignment.topCenter, // This will horizontally center from the top

        child: Positioned(
          top: 10,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: IntrinsicWidth(
              child: IntrinsicHeight(
                child: Container(
                  constraints: BoxConstraints(
                    //minHeight: 100,
                    maxHeight: MediaQuery.of(context).size.width * 0.10,
                    maxWidth: MediaQuery.of(context).size.width,
                    minWidth: 200,
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 165, 238, 255),
                          Color.fromARGB(255, 69, 195, 211),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(
                            Icons.access_alarm_rounded,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                messageTitle,
                                maxLines: 2,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                    overflow: TextOverflow.ellipsis),
                              ),
                              Text(
                                messageDis,
                                maxLines: 2,
                                style:
                                    TextStyle(overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// void toggleNotification(entry, context) {
//   print(entry);
//   if (entry == null) {
//     showNotification(entry, context);
//   } else {
//     hideOverlay(entry);
//   }
// }

void showNotification(entry, context, messageTitle, messageDis) {
  entry = OverlayEntry(
      builder: (context) => TheWebNotification(
            messageTitle: messageTitle,
            messageDis: messageDis,
          ));

  final overlay = Overlay.of(context);
  overlay.insert(entry!);
}

void hideOverlay(entry) {
  entry?.remove();
  entry = null;
}
