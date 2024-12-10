<<<<<<< HEAD
importScripts("https://www.gstatic.com/firebasejs/9.0.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.0.0/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: 'AIzaSyBA6cONKgiSYXLaVSU0pABzO-vPQ5_4zX0',
  appId: '1:447187951174:web:87f8416583c6a578f9b447',
  messagingSenderId: '447187951174',
  projectId: 'ydapp-830fe',
  //measurementId: 'xxx',
  //authDomain: 'xxx',
  //databaseURL:'xxx',
  //storageBucket: 'xxx',
=======
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
>>>>>>> d8897326d407213b04bf24182ef3ad64d422f415
});

const messaging = firebase.messaging();
//firebase.usePublicVapidKey('BKk6MPwuyDAuPyLQu_6j0ydnyu6-Q4nNkAcu87lfBJMgqv6QwRN99alsh7iyneWp6JgehZBMJyV6c6K42l-DwWM');


<<<<<<< HEAD
// Optional:
messaging.onBackgroundMessage((payload) => {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
      body: payload.notification.body,
      icon: '/firebase-logo.png'
  };

  //self.registration.showNotification(notificationTitle, notificationOptions);

  const notification = new Notification('Hi, How are you?',{
    body: 'Have a good day',
    icon: ''
  })
=======
messaging.setBackgroundMessageHandler(function(payload) {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  const notificationTitle = 'Background Message Title';
  const notificationOptions = {
    body: 'Background Message body.',
    icon: '/firebase-logo.png'
  };

  return self.registration.showNotification(notificationTitle, notificationOptions);
>>>>>>> d8897326d407213b04bf24182ef3ad64d422f415
});