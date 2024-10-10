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
});
// Necessary to receive background messages:
const messaging = firebase.messaging();
firebase.usePublicVapidKey('BKk6MPwuyDAuPyLQu_6j0ydnyu6-Q4nNkAcu87lfBJMgqv6QwRN99alsh7iyneWp6JgehZBMJyV6c6K42l-DwWM');


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
});