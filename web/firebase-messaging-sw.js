importScripts('https://www.gstatic.com/firebasejs/10.0.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.0.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "AIzaSyDoqUi_P-Q-TsyGMa1IgXoR12T_eDokpGc",
  appId: "1:468705049982:android:40ab09e9dfd65abd3ac72f",
  messagingSenderId: "468705049982",
  projectId: "faribase-acd3f",
});

const messaging = firebase.messaging();