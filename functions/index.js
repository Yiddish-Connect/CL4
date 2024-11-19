const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

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
