importScripts('https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js');

firebase.initializeApp({
  apiKey: "AIzaSyCYg35X-5ocVDYFNSZuH5IoR_NVeUIBcuc",
  databaseURL: "ydapp-830fe.firebaseio.com",
  authDomain: "ydapp-830fe.firebaseapp.com",
  projectId: "ydapp-830fe",
  storageBucket: "ydapp-830fe.appspot.com",
  messagingSenderId: "447187951174",
  appId: "1:447187951174:web:87f8416583c6a578f9b447"
});

const messaging = firebase.messaging();

messaging.setBackgroundMessageHandler(function(payload) {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  const notificationTitle = 'Background Message Title';
  const notificationOptions = {
    body: 'Background Message body.',
    icon: '/firebase-logo.png'
  };

  return self.registration.showNotification(notificationTitle, notificationOptions);
});