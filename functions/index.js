const functions = require("firebase-functions/v2");
const admin = require("firebase-admin");
admin.initializeApp();

//if you want notify all user when new event is added in yiddishlandEvents
//collection deploy this function
exports.notifyUsersOnNewEvent = functions.firestore
    .onDocumentCreated("yiddishlandEvents/{eventId}", async (event) => {
      const newEvent = event.data();

      // Get all users' FCM tokens from Firestore
      const usersSnapshot = await admin.firestore().collection("users").get();
      const tokens = [];

      usersSnapshot.forEach((userDoc) => {
        const userData = userDoc.data();
        const userTokens = [
          ...(userData.androidNotificationTokens || []),
          ...(userData.iosNotificationTokens || []),
          ...(userData.webNotificationTokens || []),
        ];
        tokens.push(...userTokens);
      });

      const payload = {
        notification: {
          title: "New Event in Yiddishland",
          body: `A new event "${newEvent.title}" has been added.`,
        },
      };

      if (tokens.length > 0) {
        try {
          const message = {
            tokens: tokens,
            notification: payload.notification,
          };
          const response = await admin.messaging()
              .sendEachForMulticast(message);
          console.log("Notification sent successfully", response);

          response.responses.forEach((result, index) => {
            if (result.error) {
              console.error(`Error sending notification to token ${
                tokens[index]}:`, result.error);
            }
          });
        } catch (error) {
          console.error("Error sending notification:", error);
        }
      } else {
        console.log("No tokens available for users.");
      }
    });

//this v1 funstion notify the user when they have new friend request
//I already deployed it on firebase
// Function to send notification on new friend request
exports.sendNotificationOnNewFriendRequest = functions.firestore
    .document("friendRequests/{requestId}")
    .onCreate(async (snap, context) => {
      const newValue = snap.data();
      const receiverId = newValue.receiverID;

      // Get the receiver's FCM tokens from Firestore
      const userDoc = await admin.firestore()
          .collection("users").doc(receiverId).get();
      const userTokens = userDoc.data();

      const payload = {
        notification: {
          title: "New Friend Request",
          body: `You have a new friend request.`,
        },
      };

      // Send notifications to all platform tokens
      const tokens = [
        ...userTokens.androidNotificationTokens || [],
        ...userTokens.iosNotificationTokens || [],
        ...userTokens.webNotificationTokens || [],
      ];

      if (tokens.length > 0) {
        try {
          const message = {
            tokens: tokens,
            notification: payload.notification,
          };
          const response = await admin.messaging()
              .sendEachForMulticast(message);
          console.log("Notification sent successfully", response);

          response.responses.forEach((result, index) => {
            if (result.error) {
              console.error(`Error sending notification
              to token ${tokens[index]}:`, result.error);
            }
          });
        } catch (error) {
          console.error("Error sending notification:", error);
        }
      } else {
        console.log("No tokens available for user:", receiverId);
      }
    });