importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: 'AIzaSyBA6cONKgiSYXLaVSU0pABzO-vPQ5_4zX0',
  appId: '1:447187951174:web:87f8416583c6a578f9b447',
  messagingSenderId: '447187951174',
  projectId: 'ydapp-830fe',
  //authDomain: 'xxx',
  //databaseURL:'xxx',
  //storageBucket: 'xxx',
  //measurementId: 'xxx',
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
// messaging.onBackgroundMessage((m) => {
//   console.log("onBackgroundMessage", m);
// });